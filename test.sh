#!/bin/bash
#Setup script
# Log all output to file
currentDate=$(date +%Y%M%D)
LOG=carino-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining Global Variables
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
USERNAME="MiguelCarino"
REPO="Carino-Systems"
latest_commit=$(curl -s "https://api.github.com/repos/$USERNAME/$REPO/commits?per_page=1" | jq -r '.[0].commit.message')
latest_commit_time=$(curl -s "https://api.github.com/repos/$USERNAME/$REPO/commits?per_page=1" | grep -m 1 '"date":' | awk -F'"' '{print $4}')
latest_kernel=$(curl -s https://www.kernel.org/releases.json | jq -r '.releases[1].version')
hardwareAcceleration=$(glxinfo | grep "direct rendering")
hardwareRenderer=$(glxinfo | grep "direct rendering" | awk '{print $3}')
archType=$(lscpu | grep -e "^Architecture:" | awk '{print $NF}')
#Declaring Global Functions
info ()
{
  echo -e "${BLUE}$1${ENDCOLOR}"
}
error ()
{
  echo -e "${RED}$1${ENDCOLOR}"
}
caution ()
{
  echo -e "${YELLOW}$1${ENDCOLOR}"
}
success ()
{
  echo -e "${GREEN}$1${ENDCOLOR}"
}
#Declaring Specific Functions
identifyDistro ()
{
if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ -n "$NAME" ]]; then
            DISTRIBUTION=$NAME
            VERSION=$VERSION_ID
        fi
    elif [[ -f /etc/lsb-release ]]; then
        source /etc/lsb-release
        if [[ -n "$DISTRIB_ID" ]]; then
            DISTRIBUTION=$DISTRIB_ID
            VERSION=$DISTRIB_RELEASE
        fi
    elif [[ -f /etc/debian_version ]]; then
        DISTRIBUTION="Debian"
        VERSION=$(cat /etc/debian_version)
    elif [[ -f /etc/centos-release ]]; then
        DISTRIBUTION=$(cat /etc/centos-release | awk '{print $1}')
        VERSION=$(cat /etc/centos-release | awk '{print $4}' | cut -d'.' -f1)
    else
        DISTRIBUTION="Unknown"
        VERSION="Unknown"
    fi
}
displayMenu ()
{
  clear
  success "-------------------------------------"
  success " $NAME $VERSION_ID Setup Script"
  success "-------------------------------------"
  echo "Version: 1.1"
  info "Detected Distribution: $DISTRIBUTION $VERSION_ID"
  info "Latest GitHub Commit: $latest_commit"
  info "Latest Linux Kernel Version: $latest_kernel"
  info "Your Kernel Version: $(uname -r)"
  info "CPU Architecture: $archType"
  if [[ $hardwareAcceleration == "No" ]]; then
    error "Hardware acceleration enabled: $hardwareAcceleration"
    error "Hardware renderer: $hardwareRenderer"
    else
    info "Hardware acceleration enabled: $hardwareAcceleration"
    info "Hardware renderer: $hardwareRenderer"
  fi
  info "-------------------------------------"
  echo "Please select an option:"
  echo "1. Technical Setup"
  echo "2. Purpose Setup"
  echo "3. Server Setup"
  echo "4. Exit"
  read optionmenu
  case $optionmenu in
    1)
        caution "Tech Setup Runs"
        techSetup
        ;;
    2)
        caution "Purpose Setup Runs"
        purposeMenu
        ;;
    3)
        caution "Server Setup Runs"
        ;;
    4)
        caution "Exit"
        ;;
    *)
        error "Bad input"
        ;;
    esac
}
desktopenvironmentMenu ()
{
  caution "What Desktop Environment you want?\n1. GNOME\n2. XFCE\n3. KDE\n4. LXQT\n5. CINNAMON\n6. MATE\n7. i3\n8. OPENBOX\n9. BUDGIE\n10. SWAY\n11. NONE"
  read option
  case $option in
    1)
        sudo $pkgm $argInstall $gnomePackages -y && sudo systemctl set-default graphical.target
        success "You have GNOME installed, moving on"
        ;;
    2)
        sudo $pkgm $argInstall $xfcePackages -y && sudo systemctl set-default graphical.target
        success "You have XFCE installed, moving on"
        ;;
    3)
        sudo $pkgm $argInstall $kdePackages -y && sudo systemctl set-default graphical.target
        success "You have KDE installed, moving on"
        ;;
    4)
        sudo $pkgm $argInstall $lxqtPackages -y && sudo systemctl set-default graphical.target
        success "You have LXQT installed, moving on"
        ;;
    5)
        sudo $pkgm $argInstall $cinnamonPackages -y && sudo systemctl set-default graphical.target
        success "You have CINNAMON installed, moving on"
        ;;
    6)
        sudo $pkgm $argInstall $matePackages -y && sudo systemctl set-default graphical.target
        success "You have MATE installed, moving on"
        ;;
    7)
        sudo $pkgm $argInstall $i3Packages -y && sudo systemctl set-default graphical.target
        success "You have i3 installed, moving on"
        ;;
    8)
        sudo $pkgm $argInstall $openboxPackages -y && sudo systemctl set-default graphical.target
        success "You have OPENBOX installed, moving on"
        ;;
    9)
        info "Desktop Environment will be added on Fedora 38"
        #sudo $pkgm $argInstall $budgiePackages -y && sudo systemctl set-default graphical.target
        #success "You have BUDGIE installed, moving on"
        ;;
    10)
        info "Desktop Environment will be added on Fedora 38"
        #sudo $pkgm $argInstall $swayPackages -y && sudo systemctl set-default graphical.target
        #success "You have SWAY installed, moving on"
        ;;
    11)
        caution "No Desktop Environment will be installed"
        ;;
    *)
        error "Wrong choice. Exiting script."
        exit
        ;;
    esac
}
graphicDrivers ()
{
info "Installing GPU drivers"
  if lspci | grep 'NVIDIA' > /dev/null;
  then
    if nvidia-smi
    then
        success "NVIDIA drivers are installed already."
    else
        caution "Nvidia card detected. Would you like to install NVIDIA packages?"
        read option
        if [ $option == y ]
        then
          info "Installing \e[32mNVIDIA\e[0m drivers"
          sudo $pkgm $argInstall $nvidiaPackages $amdPackages -y
        else
          caution "Nvidia packages will not be installed. Installing Radeon packages instead"
          sudo $pkgm $argInstall $amdPackages -y
        fi
    fi
  else
    info "NVIDIA gpu not found, installing AMD packages instead"
    sudo $pkgm $argInstall $amdPackages -y
  fi
  info "For Intel Arc drivers, please refer to https://www.intel.com/content/www/us/en/download/747008/intel-arc-graphics-driver-ubuntu.html"
}
nvtopInstall ()
{
  which nvtop > /dev/null 2>&1
    if [ $? == 0 ]
    then
        success ""
    else
        git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install && cd ../.. && rm -rf nvtop
    fi
}
purposeMenu ()
{
  clear
  success "-------------------------------------"
  success " $NAME $VERSION_ID Setup Script"
  success "-------------------------------------"
  info "Please select a purpose for your distro"
  info "-------------------------------------"
  echo " 1. Basic"
  echo " 2. Gaming"
  echo " 3. Corporate"
  echo " 4. Development"
  echo " 5. Astronomy"
  echo " 6. Comp-Neuro"
  echo " 7. Desing"
  echo " 8. Jam"
  echo " 9. Security Lab"
  echo "10. Robotics"
  echo "11. Scientific"
  echo "12. Offline"
  read optionmenu
  case $optionmenu in
    1)
        caution $1
        ;;
    2)
        caution $1
        ;;
    3)
        caution $1
        ;;
    4)
        caution $1
        ;;
    5)
        caution $1
        ;;
    6)
        caution $1
        ;;
    7)
        caution $1
        ;;
    8)
        caution $1
        ;;
    9)
        caution $1
        ;;
    10)
        caution $1
        ;;
    11)
        caution $1
        ;;
    0)
        caution $1
        ;;
    *)
        # Code to execute when $variable doesn't match any of the specified values
        ;;
    esac
}
techSetup ()
{
    error $NAME
    case $NAME in
    *Fedora*|*Nobara*|*Risi*|*Ultramarine*)
    caution "Fedora"
    pkgm=dnf
    pkgext=rpm
    argInstall=install
    argUpdate=update
    preFlags=""
    postFlags="--skip-broken -y"
    gnomePackages=$(echo "$gnomePackages" | awk '{print $2}')
    echo $gnomePackages
    if [ $(cat /etc/dnf/dnf.conf | grep fastestmirror=true) ]
      then
          break
      else
          sudo sh -c 'echo fastestmirror=true >> /etc/dnf/dnf.conf'
          sudo sh -c 'echo max_parallel_downloads=10 >> /etc/dnf/dnf.conf'
      fi 
    sudo systemctl disable NetworkManager-wait-online.service
    if [ "$os_id" == "Fedora" ]; then
        sudo $pkgm $argInstall https://mirror.fcix.net/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://opencolo.mm.fcix.net/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm fedora-workstation-repositories -y #&& sudo $pkgm update -y && sudo $pkgm install $essentialPackages -y
    else
        sudo $pkgm update -y && sudo $pkgm install $essentialPackages -y
    fi
    #desktopenvironmentMenu
    #graphicDrivers
    #nvtopInstall
    ;;
    *Red*)
    caution "RHEL"
    ;;
    *Debian*|*Ubuntu*|*Kubuntu*|*Lubuntu*|*Xubuntu*|*Uwuntu*|*Linuxmint*)
    caution "Debian"
    pkgm=apt
    pkgext=deb
    argInstall=install
    argUpdate=update
    preFlags="-f"
    postFlags="-y"
    sudo $pkgm update -y && sudo $pkgm upgrade -y
    sudo $pkgm install $essentialPackages -y
    ;;
    *Gentoo*)
    caution "Gentoo"
    ;;
    *Slackware*)
    caution "Slackware"
    ;;
    *Arch*)
    caution "Arch"
    ;;
    *Opensuse*)
    caution "openSUSE"
    ;;
    *)
    echo "2"
    ;;
    esac
}

#Declaring Packages
#Generic GNU/Linux Packages
essentialPackages="wget nano curl jq mesa-va-drivers mesa-vdpau-drivers wget figlet elinks cmake nasm ncurses-dev* git gcc htop powertop neofetch ncdu tldr sshpass ftp vsftpd lshw lm*sensors rsync rclone yt-dlp mediainfo cockpit bridge-utils cifs-utils xrdp cargo cowsay npm python3-pip *gtkglext* libxdo-*" #gcc-c++ lm_sensors.x86_64
serverPackages="netcat-traditional xserver-xorg-video-dummy openssh-server"
basicPackages="gedit firefox thunderbird mpv ffmpegthumbnailer tumbler telegram-desktop clamav clamtk libreoffice wine"
gamingPackages="steam goverlay lutris mumble"
multimediaPackages="obs-studio gimp krita blender kdenlive gstreamer* nodejs golang gscan2pdf python3-qt*" #qt5-qtbase-devel python3-qt5 python3-vapoursynth
virtconPackages="podman distrobox"
supportPackages="stacer bleachbit qbittorrent remmina filezilla barrier keepassxc bless"
amdPackages="ocl-icd-dev* opencl-headers libdrm-dev* rocm*"
nvidiaPackages="vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig" #kernel-headers kernel-devel xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs
xfcePackages="task-xfce-desktop @xfce-desktop-environment"
gnomePackages="task-gnome-desktop @workstation-product-environment"
kdePackages="task-kde-desktop @kde-desktop-environment"
lxqtPackages="task-lxqt-desktop @lxqt-desktop-environment"
cinnamonPackages="task-cinnamon-desktop @cinnamon-desktop-environment"
matePackages="task-mate-desktop @mate-desktop-environment"
i3Packages="i3 @i3-desktop-environment"
openboxPackages="openbox @basic-desktop-environment"
budgiePackages="budgie-desktop"
swayPackages="sway"
#Specific GNU/Linux Packages
intelPackages="intel-media-*driver"
essentialPackagesRPM="NetworkManager-tui xkill tigervnc-server dhcp-server"
essentialPackagesDebian="software-properties-common build-essential manpages-dev linux-headers-amd64 linux-image-amd64 net-tools x11-utils tigervnc-standalone-server tigervnc-common tightvncserver isc-dhcp-server" #libncurses5-dev libncursesw5-dev libgtkglext1
virtconPackagesRPM="@virtualization libvirt libvirt-devel virt-install qemu-kvm qemu-img virt-manager"
virtconPackagesDebian="libvirt-daemon-system libvirt-clients"
amdPackagesRPM="xorg-x11-drv-amdgpu systemd-devel"
amdPackagesDebian="xserver-xorg-video-amdgpu libsystemd-dev"
nvidiaPackagesRPM="akmod-nvidia"
nvidiaPackagesDebian="nvidia-driver* nvidia-opencl* nvidia-xconfig nvidia-vdpau-driver nvidia-vulkan*"
nvidiaPackagesUbuntu="nvidia-driver-535"
nvidiaPackagesArch="nvidia-open"
#Corporate Packages
anydesk="https://download.anydesk.com/linux/anydesk-6.2.1-1.el8.x86_64.rpm https://download.anydesk.com/linux/anydesk_6.2.1-1_amd64.deb"
rustdesk="https://github.com/rustdesk/rustdesk/releases/download/1.1.9/rustdesk-1.1.9-fedora28-centos8.rpm https://github.com/rustdesk/rustdesk/releases/download/1.1.9/rustdesk-1.1.9.deb"
microsoftPackages="microsoft-edge-stable code powershell"
zoom="https://zoom.us/client/latest/zoom_x86_64.rpm"
googlePackages="https://dl.google.com/linux/direct/google-chrome-beta_current_x86_64.rpm"
ciscoPackages="https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm vpnc"
#CustomPackages
carinoPackages="lpf-spotify-client"
identifyDistro
displayMenu