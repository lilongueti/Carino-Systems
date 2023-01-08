#!/bin/bash
#Setup script
# Log all output to file
LOG=carino-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining values in variables
version=1.20230104
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#Declaring Functions
#Distro related
identifyDistro ()
{
  # get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
case $os_id in
*fedora*|*nobara*|*risi*|*ultramarine*)
  if [ "$os_version" -ge "36" ]; then
    pkgm=dnf
    argument=install
    preFlags=""
    postFlags="--skip-broken -y"
    addMicrosoft="sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
    enableMicrosoft="sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-stable.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo"
    essentialPackages="wget nano curl gedit figlet dnf-plugins-core NetworkManager-tui dhcp-server elinks cmake nasm ncurses-devel git gcc-c++ htop powertop neofetch tldr sshpass ftp vsftpd lshw lm_sensors.x86_64 xkill rsync rclone yt-dlp mediainfo cockpit bridge-utils cifs-utils tigervnc-server xrdp cargo cowsay"
    xfcePackages="@xfce-desktop-environment chicago95-theme-all thunar-archive-plugin file-roller"
    gnomePackages="@workstation-product-environment gnome-tweaks gnome-extensions-app"
    kdePackages="@kde-desktop-environment"
    lxqtPackages="@lxqt-desktop-environment"
    cinnamonPackages="@cinnamon-desktop-environment"
    matePackages="@mate-desktop-environment"
    i3Packages="@i3-desktop-environment nnn scrot xclip thunar thunar-archive-plugin file-roller"
    openboxPackages="@basic-desktop-environment"
    budgiePackages=""
    swayPackages=""
    nvidiaPackages="kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig"
    amdPackages="ocl-icd-devel opencl-headers libdrm-devel xorg-x11-drv-amdgpu systemd-devel"
    basicPackages="firefox thunderbird mpv ffmpegthumbnailer tumbler telegram-desktop clamav clamtk https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm lpf-spotify-client"
    gamingPackages="steam goverlay lutris mumble"
    multimediaPackages="obs-studio gimp krita blender kdenlive gstreamer* qt5-qtbase-devel python3-qt5 python3-vapoursynth nodejs golang"
    virtconPackages="podman @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager wine bottles"
    supportPackages="https://download.anydesk.com/linux/anydesk-6.2.1-1.el8.x86_64.rpm stacer bleachbit deluge remmina filezilla barrier keepassxc bless"
    microsoftPackages="microsoft-edge-stable code powershell https://go.skype.com/skypeforlinux-64.rpm https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.23861-1.x86_64.rpm"
    corporateGeneric="https://zoom.us/client/latest/zoom_x86_64.rpm"
    googlePackages="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    ciscoPackages="https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm vpnc"
    dnfDistro
  else
    error "This script is only for "$os_id" 36 or newer."
  fi
  ;;
*arch*|*endeavouros*)
    pkgm=pacman
    argument=-S
    preFlags=""
    postFlags=""
    addMicrosoft="git clone https://aur.archlinux.org/microsoft-edge-stable-bin.git && cd microsoft-edge-stable-bin/ && makepkg -si && cd .. && sudo rm -rf *microsoft* && git clone https://aur.archlinux.org/visual-studio-code-bin.git && mkpkg -si && cd .. && sudo rm -rf *visual*"
    enableMicrosoft=""
    essentialPackages=""
    xfcePackages="https://aur.archlinux.org/chicago95-git.git"
    gnomePackages=""
    kdePackages=""
    lxqtPackages=""
    cinnamonPackages=""
    matePackages=""
    i3Packages=""
    openboxPackages=""
    budgiePackages=""
    swayPackages=""
    nvidiaPackages=""
    amdPackages=""
    basicPackages=""
    gamingPackages=""
    multimediaPackages=""
    virtconPackages=""
    supportPackages=""
    microsoftPackages=""
    corporateGeneric=""
    googlePackages=""
    ciscoPackages="vpnc"
    archDistro
  ;;
rhel)
  if [ "$os_version" -ge "8" ]; then
    dnfDistro
  else
    error "This script is only for "$os_id" 8 or newer."
  fi
  ;;
*debian*|*ubuntu*|*kubuntu*|*lubuntu*|*xubuntu*|*uwuntu*|*linuxmint*)
  pkgm=apt
  argument=install
  preFlags="-f"
  postFlags="-y"
  if [ "$os_id" == "debian" ]; then
      addMicrosoft="curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -"
    else
      addMicrosoft="curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc"
  fi
  enableMicrosoft="sudo apt-add-repository https://packages.microsoft.com/$os_id/$os_version/prod"
  essentialPackages="build-essential manpages-dev linux-headers-amd64 linux-image-amd64 wget nano curl gedit figlet network-manager isc-dhcp-server elinks cmake nasm libncurses5-dev libncursesw5-dev git htop powertop neofetch tldr sshpass ftp vsftpd lshw lm-sensors x11-utils rsync rclone yt-dlp mediainfo cockpit bridge-utils cifs-utils tigervnc-standalone-server tigervnc-common xrdp cargo libgl1-mesa-dev"
  xfcePackages="task-xfce-desktop"
  gnomePackages="task-gnome-desktop"
  kdePackages="task-kde-desktop"
  lxqtPackages="task-lxqt-desktop"
  cinnamonPackages="task-cinnamon-desktop"
  matePackages="task-mate-desktop"
  i3Packages="i3"
  openboxPackages="openbox"
  budgiePackages=""
  swayPackages=""
  nvidiaPackages="nvidia-driver* nvidia-opencl* nvidia-xconfig nvidia-vdpau-driver nvidia-vulkan*"
  amdPackages="ocl-icd-dev opencl-headers libdrm-dev xserver-xorg-video-amdgpu libsystemd-dev"
  basicPackages="firefox thunderbird mpv ffmpegthumbnailer tumbler telegram-desktop clamav clamtk"#https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
  gamingPackages="steam goverlay lutris mumble"
  multimediaPackages="obs-studio gimp krita blender kdenlive gstreamer* qt5-qtbase-devel python3-qt5 python3-vapoursynth nodejs golang"
  virtconPackages="podman qemu qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon python3 python3-pip virt-manager wine"
  supportPackages="stacer bleachbit deluge remmina filezilla barrier keepassxc"#https://download.anydesk.com/linux/anydesk_6.2.1-1_amd64.deb
  microsoftPackages="microsoft-edge-stable code powershell"#https://repo.skype.com/latest/skypeforlinux-64.deb https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_1.5.00.23861_amd64.deb
  corporateGeneric=""#https://zoom.us/client/latest/zoom_amd64.deb
  googlePackages=""#https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  ciscoPackages="vpnc"#https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb
  aptDistro
  ;;
*)
  info $os_id
  error "Another distro, unable to run the script"
  ;;
esac
}
dnfDistro ()
{
  firstMenu
  case $optionmenu in
    1)
      success "Workstation"
      argument=install
      if [ $(cat /etc/dnf/dnf.conf | grep fastestmirror=true) ]
      then
          echo ""
      else
          sudo sh -c 'echo fastestmirror=true >> /etc/dnf/dnf.conf'
          sudo sh -c 'echo max_parallel_downloads=10 >> /etc/dnf/dnf.conf'
      fi 
    sudo systemctl disable NetworkManager-wait-online.service
    if [ "$os_id" == "fedora" ]; then
      sudo $pkgm $argument https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm fedora-workstation-repositories -y && sudo $pkgm update -y && sudo $pkgm install $essentialPackages -y
    else
      sudo $pkgm update -y && sudo $pkgm install $essentialPackages -y
    fi
    sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:bgstack15:Chicago95/Fedora_36/home:bgstack15:Chicago95.repo
    desktopenvironmentMenu
    graphicDrivers
    nvtopInstall
    askReboot
    profileMenu
    finalTweaks
    sudo journalctl --vacuum-size=2G --vacuum-time=35d
    systemReview
    ;;
    2)
      success "Server"
    ;;
    *)
      success "Bye"
      exit;
    ;;
  esac
}
aptDistro ()
{
  firstMenu
  case $optionmenu in
    1)
      success "Workstation"
      sudo $pkgm update -y && sudo $pkgm upgrade -y
      sudo $pkgm install $essentialPackages -y
      desktopenvironmentMenu
      graphicDrivers
      nvtopInstall
      askReboot
      profileMenu
      finalTweaks
      systemReview
    ;;
    2)
      success "Server"
    ;;
    *)
      success "Bye"
      exit;
    ;;
    esac
}
#General Functions
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
firstMenu ()
{
  echo -e "${GREEN}"$os_id $os_version" Setup Scripts\nVersion $version\nHello $(whoami)\nPlease select an option:\n${YELLOW}1. "$os_id" Workstation Setup\n2. Quick $os_id Server Setup\n3. Exit${ENDCOLOR}"
  read optionmenu
}
profileMenu ()
{
  caution "Time to choose a profile.\nPlease select a Workstation profile:\n1. Basic Profile. For the most basic use cases like media playback, internet browsing, office suite, file manipulation, communication and remote assistance.\n2. Gaming profile. Is Basic profile plus popular gaming platforms and utilities, like Steam.\n3. Microsoft profile. Delivers the Microsoft ecosystem.\n4. Google profile. Delivers the Google ecosystem.\n5. Cisco profile. Delivers the Cisco ecosystem.\n6.Corporate profile. Delivers the most packages for office work, videocalls, including applications\nfor specific working ecosystems like Microsoft's, Google's and Cisco's\n9. Exit \n"
  read optionmenu
  case $optionmenu in
    1)
      sudo $pkgm $argument $preFlags $basicPackages $googlePackages $postFlags
    ;;
    2)
      sudo $pkgm $argument $preFlags $basicPackages $googlePackages $gamingPackages $postFlags
      timeout 180s steam
    ;;
    3)
      $addMicrosoft
      $enableMicrosoft
      sudo $pkgm $argument $preFlags $basicPackages $microsoftPackages $postFlags
      #onedrive pending
      sharedFolder
    ;;
    4)
      sudo $pkgm $argument $preFlags $basicPackages $googlePackages $postFlags
      #google cloud pending
    ;;
    5)
      sudo $pkgm $argument $preFlags $basicPackages $googlePackages $ciscoPackages $postFlags
    ;;
    6)
      $addMicrosoft
      $enableMicrosoft
      sudo $pkgm $argument $preFlags $basicPackages $microsoftPackages $googlePackages $ciscoPackages $corporateGeneric $postFlags
      sharedFolder
    ;;
    0)
      $addMicrosoft
      $enableMicrosoft
      sudo $pkgm $argument $preFlags $basicPackages $microsoftPackages $googlePackages $ciscoPackages $gamingPackages $multimediaPackages $virtconPackages $supportPackages $postFlags
      timeout 180s steam
      installSVP
      installDistrobox
      installproton
      sudo usermod -aG libvirt $(whoami)
      sudo systemctl enable xrdp && sudo systemctl start xrdp
      xdg-settings set default-web-browser microsoft-edge.desktop
    ;;
    *)
      error "Invalid option"
      exit
    ;;
  esac
}
desktopenvironmentMenu ()
{
  caution "What Desktop Environment you want?\n1. GNOME\n2. XFCE\n3. KDE\n4. LXQT\n5. CINNAMON\n6. MATE\n7. i3\n8. OPENBOX\n9. BUDGIE\n10. SWAY\n11. NONE"
  read option
  case $option in
    1)
        sudo $pkgm $argument $gnomePackages -y && sudo systemctl set-default graphical.target
        success "You have GNOME installed, moving on"
        ;;
    2)
        sudo $pkgm $argument $xfcePackages -y && sudo systemctl set-default graphical.target
        success "You have XFCE installed, moving on"
        ;;
    3)
        sudo $pkgm $argument $kdePackages -y && sudo systemctl set-default graphical.target
        success "You have KDE installed, moving on"
        ;;
    4)
        sudo $pkgm $argument $lxqtPackages -y && sudo systemctl set-default graphical.target
        success "You have LXQT installed, moving on"
        ;;
    5)
        sudo $pkgm $argument $cinnamonPackages -y && sudo systemctl set-default graphical.target
        success "You have CINNAMON installed, moving on"
        ;;
    6)
        sudo $pkgm $argument $matePackages -y && sudo systemctl set-default graphical.target
        success "You have MATE installed, moving on"
        ;;
    7)
        sudo $pkgm $argument $i3Packages -y && sudo systemctl set-default graphical.target
        success "You have i3 installed, moving on"
        ;;
    8)
        sudo $pkgm $argument $openboxPackages -y && sudo systemctl set-default graphical.target
        success "You have OPENBOX installed, moving on"
        ;;
    9)
        info "Desktop Environment will be added on Fedora 38"
        #sudo $pkgm $argument $budgiePackages -y && sudo systemctl set-default graphical.target
        #success "You have BUDGIE installed, moving on"
        ;;
    10)
        info "Desktop Environment will be added on Fedora 38"
        #sudo $pkgm $argument $swayPackages -y && sudo systemctl set-default graphical.target
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
  if lspci | grep 'NVIDIA' > /dev/null;
  then
    if nvidia-smi
    then
        success "NVIDIA drivers are installed already."
    else
        sudo $pkgm $argument $nvidiaPackages $amdPackages -y
    fi
  else
    sudo $pkgm $argument $amdPackages -y
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
askReboot ()
{
  caution "Would you like to reboot? (Recommended) [y/N]"
  read option
    if [ $option == y ]
    then
        sudo reboot
    else
        caution "No reboot was requested."
    fi
}
installproton ()
{
  if [ $(ls ~/.steam/root/ | grep compatibilitytools.d) ]
  then
      CURRENTVERSION=$(ls ~/.steam/root/compatibilitytools.d | tail -c 3)
      for I in 50 49 48 47 46 45 44 43
       do
           if [[ $CURRENTVERSION -eq $I ]]
           then
               echo -e "${GREEN}You already have the latest ProtonGE $I version.${ENDCOLOR}"
           else
               PROTONVERSION=$I
               wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-$PROTONVERSION/GE-Proton7-$PROTONVERSION.tar.gz &> /dev/null
               if [ $? -eq 0 ]
               then
                   echo -e "Installing version $PROTONVERSION..."
                   sudo tar -xf GE-Proton7-$PROTONVERSION.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-$PROTONVERSION.tar.gz
                   echo -e "${GREEN}ProtonGE $PROTONVERSION has been installed.${ENDCOLOR}"
                   break
               else
                   echo -e "${RED}Version $PROTONVERSION not found (yet).${ENDCOLOR}" &> /dev/null
               fi
           fi
       done
  else
      sudo mkdir ~/.steam/ &> /dev/null
      sudo mkdir ~/.steam/root/ &> /dev/null
      sudo mkdir ~/.steam/root/compatibilitytools.d
      installproton
  fi
}
installSVP ()
{
  pkgs="/home/$(whoami)/SVP\ 4/SVPManager"
        which $pkgs > /dev/null 2>&1
        if [ $? == 0 ]
        then
          echo "SVP is already installed"
        else
            wget https://www.svp-team.com/files/svp4-linux.4.5.210-1.tar.bz2
            tar -xf svp4-linux.4.5.210-1.tar.bz2
            sudo chmod +x svp4-linux-64.run
            sudo -u $(whoami) ./svp4-linux-64.run && rm svp4-latest* svp4-linux-64.run 
        fi
}
installDistrobox ()
{
  which $pkgs > /dev/null 2>&1
        if [ $? == 0 ]
        then
          echo ""
        else
          curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
          distrobox-create --name fedora --image quay.io/fedora/fedora:37 -Y
          #distrobox-create --name tumbleweed --image registry.opensuse.org/opensuse/tumbleweed:latest -Y
          distrobox-create --name ubuntu18 --image docker.io/library/ubuntu:18.04 -Y
          #distrobox-create --name ubuntu20 --image docker.io/library/ubuntu:20.04 -Y
          distrobox-create --name ubuntu22 --image docker.io/library/ubuntu:22.04 -Y
          #distrobox-create --name rhel8 --image registry.access.redhat.com/ubi8/ubi -Y
          distrobox-create --name rhel9 --image registry.access.redhat.com/ubi9/ubi -Y
          distrobox-create --name arch --image docker.io/library/archlinux:latest -Y
        fi
}
sharedFolder ()
{
  #Mounting Windows Shared folder
        echo "Do you want to setup a Windows Shared Folder?"
        read option
        if [ $option == y ]
        then
            echo "What is the server name you wish to connect to?"
            read server
            echo "What is the shared folder of $server?"
            read folder
            echo "What is the user to connect to $folder in $server?"
            read srvuser2o mount.cifs //$server/$folder /home/$(whoami)/WinFiles/ -o user=$srvuser
            echo "Windows Shared Folder has been successfully mounted!"
        else
            echo -e "No Windows shared folders were added\n--------------------------------------"
        fi
}
finalTweaks ()
{
  #Hostname
  if [[ $(hostname) == 'fedora' ]];
  then
      echo "Please provide a hostname for the computer"
      read hostname
      sudo hostnamectl set-hostname --static $hostname
  else
      echo 'hostname was not changed'
  fi
  #Desktop Environment tweaks
  if [ $XDG_SESSION_DESKTOP = "gnome" ] || [ $XDG_SESSION_DESKTOP = "xfce" ]
  then
      gsettings set org.gnome.desktop.interface color-scheme prefer-dark
      gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
      gsettings set org.gnome.desktop.session idle-delay 0
      xdg-mime default thunar.desktop inode/directory
  else
      echo ""
  fi
}
systemReview ()
{
  cowsay "The process has been completed, here is a review of your system." | neofetch
}
identifyDistro