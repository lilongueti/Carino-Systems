#!/bin/bash
# Setup script
# Log all output to file
currentDate=$(date +%Y%M%D)
LOG=carino-setup$version.log
exec > >(tee -a "$LOG") 2>&1
# Defining Global Variables
RED="\e[31m"; BLUE="\e[94m"; GREEN="\e[32m"; YELLOW="\e[33m"; ENDCOLOR="\e[0m";USERNAME="MiguelCarino"; REPO="Carino-Systems"; latest_commit=$(curl -s "https://api.github.com/repos/$USERNAME/$REPO/commits?per_page=1" | jq -r '.[0].commit.message');latest_commit_time=$(curl -s "https://api.github.com/repos/$USERNAME/$REPO/commits?per_page=1" | grep -m 1 '"date":' | awk -F'"' '{print $4}');latest_kernel=$(curl -s https://www.kernel.org/releases.json | jq -r '.releases[1].version');hardwareAcceleration=$(glxinfo | grep "direct rendering");hardwareRenderer=$(glxinfo | grep "direct rendering" | awk '{print $3}');archType=$(lscpu | grep -e "^Architecture:" | awk '{print $NF}'); locale_language=$(locale | grep "LANG=" | cut -d'=' -f2)
# Localized Display Menus
tech_setup_en_US="-------------------------------------\n $NAME $VERSION_ID Setup Script\n-------------------------------------\nVersion: 1.1\nDetected Distribution: $DISTRIBUTION $VERSION_ID\nLatest GitHub Commit: $latest_commit\nLatest Linux Kernel Version: $latest_kernel\nYour Kernel Version: $(uname -r)\nCPU Architecture: $archType\nHardware acceleration enabled: $hardwareAcceleration\nHardware renderer: $hardwareRenderer\n-------------------------------------\nPlease select an option:\n1. Technical Setup\n2. Purpose Setup\n3. Server Setup\n4. Exit"
tech_setup_ja_JP="-------------------------------------\n $NAME $VERSION_ID セットアップ スクリプト\n-------------------------------------\nバージョン: 1.1\nDetected 検出されたディストリビューション： $DISTRIBUTION $VERSION_ID\n最新のGitHubコミット： $latest_commit\n最新のLinuxカーネルバージョン： $latest_kernel\nあなたのカーネルバージョン： $(uname -r)\nCPUアーキテクチャ： $archType\nハードウェアアクセラレーションが有効： $hardwareAcceleration\nハードウェアレンダラー： $hardwareRenderer\n-------------------------------------\nオプションを選択してください：\n1. 技術的なセットアップ\n2. 目的のセットアップ\n3. 3. サーバーセットアップ\n4. 終了"
tech_setup_ru_RU="-------------------------------------\n $NAME $VERSION_ID Скрипт установки\n-------------------------------------\nВерсия: 1.1\nОбнаруженное распространение: $DISTRIBUTION $VERSION_ID\nПоследний коммит в GitHub: $latest_commit\nПоследняя версия ядра Linux: $latest_kernel\nВаша версия ядра: $(uname -r)\nАрхитектура ЦП: $archType\nАппаратное ускорение отключено: $hardwareAcceleration\nАппаратный рендерер: $hardwareRenderer\n-------------------------------------\nПожалуйста, выберите опцию:\n1. Техническая настройка\n2. 2. Назначение настройки\n3. Настройка сервера\n4. Выход"
tech_setup_es_ES="-------------------------------------\n $NAME $VERSION_ID Setup Script\n-------------------------------------\nVersion: 1.1\nDistribución Detectada: $DISTRIBUTION $VERSION_ID\nLatest GitHub Commit: $latest_commit\nLatest Linux Kernel Version: $latest_kernel\nYour Kernel Version: $(uname -r)\nCPU Architecture: $archType\nHardware acceleration enabled: $hardwareAcceleration\nHardware renderer: $hardwareRenderer\nAceleración de Hardware habilitada: $hardwareAcceleration\nRenderizador de Hardware: $hardwareRenderer\n-------------------------------------\nPor favor, seleccione una opción:\n1. Configuración Técnica\n2. Configuración para propósito de uso\n3. Configuración como servidor\n4. Salir"
purpose_setup_en_US="\n\n\-------------------------------------nPlease select a purpose for your distro\n-------------------------------------\n1. Basic\n 2. Gaming\n 3. Corporate\n 4. Development\n 5. Astronomy\n 6. Comp-Neuro\n 7. Desing\n 8. Jam\n 9. Security Lab\n10. Robotics\n11. Scientific\n12. Offline"
purpose_setup_en_US="-------------------------------------\n$NAME $VERSION_ID Setup Script\nPlease select a purpose for your distro\n-------------------------------------\n 1. Basic. Most common non-commercial software for basic needs.\n 2. Gaming. Most popular gaming and basic software.\n 3. Corporate. \n 4. Development\n 5. Astronomy\n 6. Comp-Neuro\n 7. Desing\n 8. Jam\n 9. Security Lab\n10. Robotics\n11. Scientific\n12. Offline"
purpose_setup_ja_JP="-------------------------------------\n$NAME $VERSION_ID Setup Script\nPlease select a purpose for your distro\n-------------------------------------\n 1. Basic\n 2. Gaming\n 3. Corporate\n 4. Development\n 5. Astronomy\n 6. Comp-Neuro\n 7. Desing\n 8. Jam\n 9. Security Lab\n10. Robotics\n11. Scientific\n12. Offline"
purpose_setup_ru_RU="-------------------------------------\n$NAME $VERSION_ID Setup Script\nPlease select a purpose for your distro\n-------------------------------------\n 1. Basic\n 2. Gaming\n 3. Corporate\n 4. Development\n 5. Astronomy\n 6. Comp-Neuro\n 7. Desing\n 8. Jam\n 9. Security Lab\n10. Robotics\n11. Scientific\n12. Offline"
purpose_setup_es_ES="-------------------------------------\n$NAME $VERSION_ID Setup Script\nPlease select a purpose for your distro\n-------------------------------------\n 1. Basic\n 2. Gaming\n 3. Corporate\n 4. Development\n 5. Astronomy\n 6. Comp-Neuro\n 7. Desing\n 8. Jam\n 9. Security Lab\n10. Robotics\n11. Scientific\n12. Offline"

#Declaring Global Functions
info (){
  echo -e "${BLUE}$1${ENDCOLOR}"
}
error (){
  echo -e "${RED}$1${ENDCOLOR}"
}
caution (){
  echo -e "${YELLOW}$1${ENDCOLOR}"
}
success (){
  echo -e "${GREEN}$1${ENDCOLOR}"
}
# Declaring Specific Functions
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
    case $NAME in
    *Fedora*|*Nobara*|*Risi*|*Ultramarine*)
    pkgm=dnf
    pkgext=rpm
    argInstall=install
    argUpdate=update
    preFlags=""
    postFlags="--skip-broken -y"
    essentialPackages="$essentialPackages $essentialPackagesRPM"
    amdPackages="$amdPackages $amdPackagesRPM"
    nvidiaPackages="$nvidiaPackages $nvidiaPackagesRPM"
    virtconPackage="$virtconPackages $virtconPackagesRPM"
    addMicrosoft="sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
    enableMicrosoft="sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-stable.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo"
    desktopOption=2
    ;;
    *Red*)
    caution "RHEL"
    pkgm=dnf
    pkgext=rpm
    argInstall=install
    argUpdate=update
    preFlags=""
    postFlags="--skip-broken -y"
    essentialPackages="$essentialPackages $essentialPackagesRPM"
    amdPackages="$amdPackages $amdPackagesRPM"
    nvidiaPackages="$nvidiaPackages $nvidiaPackagesRPM"
    virtconPackage="$virtconPackages $virtconPackagesRPM"
    desktopOption=2
    ;;
    *Debian*|*Ubuntu*|*Kubuntu*|*Lubuntu*|*Xubuntu*|*Uwuntu*|*Linuxmint*)
    pkgm=apt
    pkgext=deb
    argInstall=install
    argUpdate=update
    preFlags="-f"
    postFlags="-y -m"
    essentialPackages="$essentialPackages $essentialPackagesDebian"
    amdPackages="$amdPackages $amdPackagesDebian"
    nvidiaPackages="$nvidiaPackages $nvidiaPackagesDebian"
    virtconPackage="$virtconPackages $virtconPackagesDebian"
    desktopOption=1
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
    displayMenu
}
load_dictionary() {
    case "$locale_language" in
        *en_US* | *en* | *en_*)
            echo "BULLSHIT"
            printingDisplay="${phase}_en_US"
            info "${!printingDisplay}"
            ;;
        *es_ES* | *es_ES* | es | es_)
            printingDisplay="${phase}_es_ES"
            info "${!printingDisplay}"
            ;;
	    *ru_RU* | *ru_RU* | ru | ru_)
            printingDisplay="${phase}_ru_RU"
            info "${!printingDisplay}"
            ;;
	    *ja_JP* | *ja_JP* | *ja* | *ja_*)
            printingDisplay="${phase}_ja_JP"
            info "${!printingDisplay}"
            ;;
	    *)
            error "Locale not supported. Using default English (en) dictionary."
            printingDisplay="${phase}_en_US"
            info "${!printingDisplay}"
            ;;
    esac
}

displayMenu ()
{
  clear
  phase=tech_setup
  load_dictionary
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
desktopenvironment ()
{
    if [-n $XDG_CURRENT_DESKTOP]; then
        desktopenvironmentMenu
    else
        success "You have $XDG_CURRENT_DESKTOP installed, moving on"
    fi
}
desktopenvironmentMenu ()
{
  caution "What Desktop Environment you want?\n1. GNOME\n2. XFCE\n3. KDE\n4. LXQT\n5. CINNAMON\n6. MATE\n7. i3\n8. OPENBOX\n9. BUDGIE\n10. SWAY\n11. NONE"
  read option
  case $option in
    1)
        gnomePackages="$(echo "$gnomePackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $gnomePackages  && sudo systemctl set-default graphical.target
        success "You have GNOME installed, moving on"
        ;;
    2)
        xfcePackages="$(echo "$xfcePackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $xfcePackages -y && sudo systemctl set-default graphical.target
        success "You have XFCE installed, moving on"
        ;;
    3)
        kdePackages="$(echo "$kdePackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $kdePackages -y && sudo systemctl set-default graphical.target
        success "You have KDE installed, moving on"
        ;;
    4)
        lxqtPackages="$(echo "$lxqtPackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $lxqtPackages -y && sudo systemctl set-default graphical.target
        success "You have LXQT installed, moving on"
        ;;
    5)
        cinnamonPackages="$(echo "$cinnamonPackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $cinnamonPackages -y && sudo systemctl set-default graphical.target
        success "You have CINNAMON installed, moving on"
        ;;
    6)
        matePackages="$(echo "$matePackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $matePackages -y && sudo systemctl set-default graphical.target
        success "You have MATE installed, moving on"
        ;;
    7)
        i3Packages="$(echo "$i3Packages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $i3Packages -y && sudo systemctl set-default graphical.target
        success "You have i3 installed, moving on"
        ;;
    8)
        openboxPackages="$(echo "$openboxPackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $openboxPackages -y && sudo systemctl set-default graphical.target
        success "You have OPENBOX installed, moving on"
        ;;
    9)
        budgiePackages="$(echo "$budgiePackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $budgiePackages -y && sudo systemctl set-default graphical.target
        success "You have BUDGIE installed, moving on"
        ;;
    10)
        swayPackages="$(echo "$swayPackages" | awk '{print $desktopOption}')"
        sudo $pkgm $argInstall $swayPackages -y && sudo systemctl set-default graphical.target
        success "You have SWAY installed, moving on"
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
        info "Already have nvtop installed."
    else
        git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install && cd ../.. && rm -rf nvtop
        success "nvtop has been successfully installed."
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
purposeMenu ()
{
  phase=purpose_setup
  clear
  load_dictionary
  read optionmenu
  case $optionmenu in
    1)
        caution $1
        sudo $pkgm $argInstall $preFlags $basicPackages $supportPackages $postFlags
        ;;
    2)
        caution $1
        sudo $pkgm $argInstall $preFlags $basicPackages $supportPackages $gamingPackages $postFlags
        ;;
    3)
        caution $1
        case $NAME in
        *Fedora*|*Nobara*|*Risi*|*Ultramarine*)
            addMicrosoft="sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
            enableMicrosoft="sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-stable.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo"
        ;;
        *Red*)
            addMicrosoft="sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
            enableMicrosoft="sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-stable.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo"
        ;;
        *Debian*|*Ubuntu*|*Kubuntu*|*Lubuntu*|*Xubuntu*|*Uwuntu*|*Linuxmint*)
            if [[ "$NAME" == "Debian" ]]; then
            addMicrosoft="curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -"
            else
            addMicrosoft="curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc"
            fi
        ;;
        esac
        $addMicrosoft
        $enableMicrosoft
        sudo $pkgm $argInstall $preFlags $basicPackages $supportPackages $microsoftPackages $postFlags
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
    if [ $(cat /etc/dnf/dnf.conf | grep fastestmirror=true) ]
      then
          echo ""
      else
          sudo sh -c 'echo fastestmirror=true >> /etc/dnf/dnf.conf'
          sudo sh -c 'echo max_parallel_downloads=10 >> /etc/dnf/dnf.conf'
      fi 
    sudo systemctl disable NetworkManager-wait-online.service
    if [ "$os_id" == "Fedora" ]; then
        sudo $pkgm $argInstall https://mirror.fcix.net/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://opencolo.mm.fcix.net/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm fedora-workstation-repositories -y && sudo $pkgm update -y && sudo $pkgm install $essentialPackages -y
    else
        sudo $pkgm update -y && sudo $pkgm install $essentialPackages -y
    fi
    ;;
    *Red*)
    caution "RHEL"
    ;;
    *Debian*|*Ubuntu*|*Kubuntu*|*Lubuntu*|*Xubuntu*|*Uwuntu*|*Linuxmint*)
    caution "Debian"
    sudo $pkgm update -y && sudo $pkgm upgrade -y
    sudo $pkgm install $essentialPackages -y
    gnomePackages=$(echo "$gnomePackages" | awk '{print $1}')
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
    desktopenvironment
    graphicDrivers
    nvtopInstall
    askReboot
    displayMenu
}
installSVP ()
{
  pkgs="/home/$(whoami)/SVP\ 4/SVPManager"
        which $pkgs > /dev/null 2>&1
        if [ $? == 0 ]
        then
          echo "SVP is already installed"
        else
            wget https://www.svp-team.com/files/svp4-linux.4.5.210-2.tar.bz2
            tar -xf svp4-linux.4.5.210-2.tar.bz2
            sudo chmod +x svp4-linux-64.run
            sudo -u $(whoami) ./svp4-linux-64.run && rm svp4-latest* svp4-linux-64.run 
        fi
}
finalTweaks ()
{
  #Hostname
  if [[ $(hostname) == $hostnamegiven ]];
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
updateSystem ()
{
  sudo $pkgm $argUpdate -y
  success "Your system has been updated"
}
# Declaring Packages
# Generic GNU/Linux Packages
essentialPackages="wget nano curl jq mesa-va-drivers mesa-vdpau-drivers elinks cmake nasm ncurses-dev* git gcc ncdu sshpass ftp vsftpd lshw lm*sensors rsync rclone mediainfo bridge-utils cifs-utils cargo npm python3-pip *gtkglext* libxdo-*" #gcc-c++ lm_sensors.x86_64
serverPackages="netcat-traditional xserver-xorg-video-dummy openssh-server cockpit"
basicPackages="gedit yt-dlp firefox thunderbird mpv ffmpegthumbnailer tumbler telegram-desktop clamav clamtk libreoffice wine cowsay xrdp htop powertop neofetch tldr figlet obs-studio"
gamingPackages="steam goverlay lutris mumble"
multimediaPackages="gimp krita blender kdenlive gstreamer* nodejs golang gscan2pdf python3-qt*" #qt5-qtbase-devel python3-qt5 python3-vapoursynth
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
budgiePackages="budgie-desktop budgie-desktop"
swayPackages="sway sway"
# Specific GNU/Linux Packages
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
# Corporate Packages
anydesk="https://download.anydesk.com/linux/anydesk-6.2.1-1.el8.x86_64.rpm https://download.anydesk.com/linux/anydesk_6.2.1-1_amd64.deb"
rustdesk="https://github.com/rustdesk/rustdesk/releases/download/1.1.9/rustdesk-1.1.9-fedora28-centos8.rpm https://github.com/rustdesk/rustdesk/releases/download/1.1.9/rustdesk-1.1.9.deb"
microsoftPackages="microsoft-edge-stable code powershell"
zoom="https://zoom.us/client/latest/zoom_x86_64.rpm"
googlePackages="https://dl.google.com/linux/direct/google-chrome-beta_current_x86_64.rpm"
ciscoPackages="https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm vpnc"
# CustomPackages
carinoPackages="lpf-spotify-client"
identifyDistro