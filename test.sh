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
    case $NAME in
    *fedora*|*nobara*|*risi*|*ultramarine*)
    caution "FEDORA"
    ;;
    *rhel*)
    caution "RHEL"
    ;;
    *debian*|*ubuntu*|*kubuntu*|*lubuntu*|*xubuntu*|*uwuntu*|*linuxmint*)
    echo "DEBIAN"
    ;;
    *gentoo*)
    echo "2"
    ;;
    *slackware*)
    echo "2"
    ;;
    *arch*)
    echo "2"
    ;;
    *opensuse*)
    echo "2"
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