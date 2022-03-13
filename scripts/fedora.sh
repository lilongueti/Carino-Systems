#!/bin/bash

# Log all output to file
LOG=carino-setup.log
exec > >(tee -a "$LOG") 2>&1
#Defining functions
#Defining values in variables
nvidia=n
support=n
mpv=n
sharedfolder=n
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
# if os_id is fedora and os_version is greater than or equal to 35
if [ "$os_id" = "fedora" ] && [ "$os_version" -ge 35 ]; then
    # run fedora setup script
    MIGRATABLE=true
# elif it's not f35 or newer
elif [ "$os_id" = "fedora" ] || [ "$os_version" -lt 35 ]; then
    # set MIGRATABLE to false
    echo "This script is only for Fedora 35 or newer."
else
# set MIGRATABLE to false
    echo "OS $os_id version $os_version is not supported. Please run this script on a copy of Fedora Linux 35 or newer."
    MIGRATABLE=false
fi
#Getting User
user=$(awk -F: '{ print $1}' /etc/passwd |& tail -1)
#Main Menu
echo -e "Hello $user\nPlease select a profile:\n1. Basic profile\n2. Gaming profile\n3. Corporate profile\n4. Migrate to Ultramarine Linux\n5. Install Nvidia drivers\n6. Exit"
read choice
case $choice in
  #Gaming profile starts
  "2")
    echo "Gaming profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour libreoffice-* -y
    #Adding repos and updating system
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    sudo dnf install steam goverlay lutris mumble -y && flatpak install flathub com.discordapp.Discord -y
    #Installing Proton EG
    DESTDIR="~/.steam/root/compatibilitytools.d"
    if [[ -d $DESTDIR ]]
    then
        echo "$DESTDIR is already on your system."
    else
        sudo mkdir ~/.steam/
        sudo mkdir ~/.steam/root/
        sudo mkdir ~/.steam/root/compatibilitytools.d
        wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/7.1-GE-2/Proton-7.1-GE-2.tar.gz && sudo tar -xf Proton-7.1-GE-2.tar.gz -C ~/.steam/root/compatibilitytools.d && rm Proton-7.1-GE-2.tar.gz
    fi
    ;&
  #Basic profile starts
  "1")
    echo "Basic profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour libreoffice-* -y
    #Adding repos and updating system
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    #Installing packages
    sudo dnf install google-chrome-stable celluloid keepassxc thunderbird transmission gimp krita htop powertop neofetch mediainfo obs-studio wine NetworkManager-tui yt-dlp cmake lshw gnome-tweaks gnome-extensions-app git xkill tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils tigervnc-server xrdp dnf-plugins-core -y && flatpak install flathub org.telegram.desktop com.spotify.Client org.onlyoffice.desktopeditors -y
    support=y
    nvidia=y
    ;;
  #Corporate profile starts
  "3")
    echo "Corporate profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour libreoffice-* -y
    #Adding repos
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo rpm --import https://keys.openpgp.org/vks/v1/by-fingerprint/034F7776EF5E0C613D2F7934D29FBD5F93C0CFC3 && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo dnf config-manager --add-repo  https://rpm.librewolf.net && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    #Installing packages
    sudo dnf install celluloid keepassxc thunderbird transmission gimp htop powertop remmina neofetch mediainfo microsoft-edge-stable code obs-studio wine NetworkManager-tui yt-dlp cmake lshw gnome-tweaks gnome-extensions-app elinks git xkill tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server xrdp powershell dnf-plugins-core -y && flatpak install flathub org.telegram.desktop us.zoom.Zoom com.dropbox.Client com.spotify.Client org.onlyoffice.desktopeditors com.anydesk.Anydesk com.skype.Client com.microsoft.Teams com.github.gi_lom.dialect com.slack.Slack -y
    support=y
    nvidia=y
    sharedfolder=y
    ;;
  #Ultramarine Linux migration process
  "4")
    bash <(curl -s https://ultramarine-linux.org/migrate.sh)
    ;;
  #NVIDIA driver installation
  "5")
    nvidia=y
    ;;
  #Exit program
  "6")
    echo "Exit" 
    exit
    ;;
  #Carino profile starts
  "0")
    echo "Carino profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour firefox libreoffice-* -y
    #Adding repos and updating
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo rpm --import https://keys.openpgp.org/vks/v1/by-fingerprint/034F7776EF5E0C613D2F7934D29FBD5F93C0CFC3 && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo dnf config-manager --add-repo  https://rpm.librewolf.net && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/ && sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    #Installing packages
    sudo dnf install keepassxc librewolf thunderbird transmission gimp krita kdenlive shotcut blender htop powertop remmina neofetch mediainfo microsoft-edge-stable brave-browser code obs-studio wine NetworkManager-tui yt-dlp cmake lshw gnome-tweaks gnome-extensions-app elinks git xkill mumble goverlay tldr steam qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server xrdp powershell dnf-plugins-core -y && flatpak install flathub org.telegram.desktop com.spotify.Client org.onlyoffice.desktopeditors com.anydesk.Anydesk com.github.gi_lom.dialect com.skype.Client -y
    #Installing packages not available in rpm or flatpak repos
    which distrobox > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "distrobox is already installed$'\e[0m"
    else
        curl https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
    fi
    which ipfs-desktop > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "ipfs-desktop is already installed"
    else
        sudo dnf install https://github.com/ipfs/ipfs-desktop/releases/download/v0.18.1/ipfs-desktop-0.18.1-linux-x86_64.rpm -y
    fi
    #Installing SVP
    pkgs="/home/$user/SVP\ 4/SVPManager"
    which $pkgs > /dev/null 2>&1
    if [ $? == 0 ]
    then
      echo "SVP is already installed"
    else
        wget https://www.svp-team.com/files/svp4-latest.php?linux
        tar -xf svp4-latest.php?linux
        sudo -u $user ./svp4-linux-64.run && rm svp4-latest*
    fi
    support=y
    mpv=y
    nvidia=y
    ;;
  *)
    echo "Invalid option"
    exit
    ;;
esac
#Installing packages needed by all profiles
#Rustdesk for support
if [ $support == y ]
then
    which rustdesk > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "rustdesk is already installed"
    else
        sudo dnf install https://github.com/rustdesk/rustdesk/releases/download/1.1.8/rustdesk-1.1.8-fedora28-centos8.rpm -y
    fi
fi
#echo $mpv
if [ $mpv == y ]
then
    #Checking for mpv installation and building it from the repo if necessary
    which mpv > /dev/null 2>&1
    if [ $? == 0 ]
    then
      echo "Mpv is already installed"
      sudo dnf builddep mpv -y && sudo git clone https://github.com/mpv-player/mpv && cd mpv/ && sudo ./bootstrap.py && sudo ./waf configure --enable-vapoursynth && sudo ./waf && sudo ./waf install && cd .. && sudo rm -r mpv
    fi
#else
#    echo 'THE mpv process has been skipped'
fi
#Installing NVIDIA drivers
#echo $nvidia
if [ $nvidia == y ]
then
    if lspci | grep 'NVIDIA' > /dev/null;
    then
        if [which akmod-nvidia &>/dev/null]
        then
            #needs depuration (too many packages?)
            sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers -y && sudo nvidia-xconfig
            pkgs='nvtop'
            if [which $pkgs &>/dev/null]
            then
                git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install && cd ../.. && rm -rf nvtop
            else
                echo "nvtop is already installed"
            fi
        else
            echo "NVIDIA drivers are installed already."
        fi
    else
        echo "NVIDIA drivers were not installed."
    fi
#else
#    echo 'THE NVIDIA process has been skipped'
fi
#Mounting Windows Shared folder
if [ $sharedfolder == y]
then
    echo $'\e[1;36m'Do you want to setup a Windows Shared Folder?$'\e[0m'
    echo $'\e[1;36m'¿Quieres agregar una carpeta compartida de Windows? $'\e[0m'
    echo $'\e[1;36m'Вы хотите настроить общую папку Windows? $'\e[0m'
    echo $'\e[1;36m'Windows 共有フォルダをセットアップしますか?$'\e[0m'
    read option
    echo $'\e[1;32m'--------------------------------------$'\e[0m'
    if [ $option == y ]
    then
        echo $'\e[1;36m'What is the server name you wish to connect to?$'\e[0m'
        echo $'\e[1;36m'¿Cuál es el nombre del servidor al que se desea conectar? $'\e[0m'
        echo $'\e[1;36m'С каким именем сервера вы хотите подключиться? $'\e[0m'
        echo $'\e[1;36m'接続するサーバー名を指定してください。$'\e[0m'
        read server
        echo $'\e[1;36m'What is the shared folder of $server?$'\e[0m'
        echo $'\e[1;36m'¿A qué carpeta compartida del $server desea conectarse?$'\e[0m'
        echo $'\e[1;36m'Что такое общая папка с $server? $'\e[0m'
        echo $'\e[1;36m'$serverの共有フォルダとは何ですか。 $'\e[0m'
        read folder
        echo $'\e[1;36m'What is the user to connect to $folder in $server?$'\e[0m'
        echo $'\e[1;36m'¿Cuál es el usuario que se va a conectar a la carpeta $folder en $server?$'\e[0m'
        echo $'\e[1;36m'Какой пользователь должен подключиться к папке на сервере? $'\e[0m'
        echo $'\e[1;36m'$server内の$folderに接続するユーザーは何ですか。 $'\e[0m'
        read srvuser
        sudo mkdir /home/$(whoami)/WinFiles/ && sudo mount.cifs //$server/$folder /home/$(whoami)/WinFiles/ -o user=$srvuser
        echo $'\e[1;36m'Windows Shared Folder has been successfully mounted!$'\e[0m'
        echo $'\e[1;36m'¡La carpeta compartida de Windows se ha montado correctamente! $'\e[0m'
        echo $'\e[1;36m'Общая папка Windows успешно смонтирована! $'\e[0m'
        echo $'\e[1;36m'Windows 共有フォルダが正常にマウントされました。$'\e[0m'
        echo $'\e[1;32m'--------------------------------------$'\e[0m'

    else
        echo $'\e[1;31m'No Windows shared folders were added$'\e[0m'
        echo $'\e[1;31m'--------------------------------------$'\e[0m'
    fi
fi
#Setting up a hostname
#echo "Testing hostname"
if [[ $(hostname) == 'fedora' ]];
then
    echo $'\e[1;32m'Please provide a hostname for the computer$'\e[0m'
    read hostname
    echo 'hostname was not changed'
    sudo hostnamectl set-hostname --static $hostname
fi
#Showing system review
echo $'\e[1;32m'The process has been completed, here is a review of your system.$'\e[0m'
echo $'\e[1;32m'El proceso se ha completado, aquí hay una revisión de su sistema.$'\e[0m'
echo $'\e[1;32m'Процесс завершен, вот обзор вашей системы.$'\e[0m'
echo $'\e[1;32m'プロセスが完了しました、 ここにあなたのシステムのレビューがあります。$'\e[0m'
neofetch
#asking for a reboot
if [ $nvidia == y ]
then
    echo "You should reboot to make sure the process is completed, do you want to reboot now?"
    read reboot
    if [ $reboot == y ]
    then
        sudo reboot
    else
        echo "The system will not be rebooted. The script has been concluded."
    fi
fi