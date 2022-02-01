#!/bin/bash
echo $'\e[1;32m'Basic profile for Fedora$'\e[0m'
echo $'\e[1;32m'Perfil básico de Fedora$'\e[0m'
echo $'\e[1;32m'Базовый профиль для Fedora$'\e[0m'
echo $'\e[1;32m'Fedora の基本プロファイル$'\e[0m'
echo $'\e[1;32m'--------------------------------------$'\e[0m'
#Getting info
user=$(awk -F: '{ print $1}' /etc/passwd |& tail -1)
#Adding repos
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#Updating the system and changing GNOME global settings
gsettings set org.gnome.desktop.interface clock-format 24h && gsettings set org.gnome.desktop.interface clock-show-seconds true && gsettings set org.gnome.desktop.interface clock-show-date true && gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark && gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']" && sudo dnf update -y
#Installing packages
sudo dnf install keepassxc thunderbird transmission gimp krita blender htop powertop neofetch mediainfo obs-studio wine NetworkManager-tui yt-dlp cmake lshw gnome-tweaks gnome-extensions-app git xkill tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils tigervnc-server xrdp dnf-plugins-core -y && flatpak install flathub org.telegram.desktop com.spotify.Client org.onlyoffice.desktopeditors -y
#Installing packages not available in rpm or flatpak repos
which rustdesk > /dev/null 2>&1
if [ $? == 0 ]
then
    echo $'\e[1;32m'rustdesk is already installed$'\e[0m'
    echo $'\e[1;32m'rustdesk ya está instalado$'\e[0m'
    echo $'\e[1;32m'rustdesk уже установлен$'\e[0m'
    echo $'\e[1;32m'rustdesk は既にインストールされています。$'\e[0m'
    echo $'\e[1;32m'--------------------------------------$'\e[0m'
else
    sudo dnf install https://github.com/rustdesk/rustdesk/releases/download/1.1.8/rustdesk-1.1.8-fedora28-centos8.rpm -y
fi
#Checking for mpv installation and building it from the repo if necessary
which mpv > /dev/null 2>&1
if [ $? == 0 ]
then
  echo $'\e[1;32m'Mpv is already installed$'\e[0m'
  echo $'\e[1;32m'Mpv ya está instalado$'\e[0m'
  echo $'\e[1;32m'Mpv уже установлен$'\e[0m'
  echo $'\e[1;32m'Mpv は既にインストールされています。$'\e[0m'
  echo $'\e[1;32m'--------------------------------------$'\e[0m'
else
  sudo dnf builddep mpv -y && sudo git clone https://github.com/mpv-player/mpv && cd mpv/ && sudo ./bootstrap.py && sudo ./waf configure --enable-vapoursynth && sudo ./waf && sudo ./waf install && cd .. && sudo rm -r mpv
fi
#Installing NVIDIA drivers
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
                echo $'\e[1;32m'nvtop is already installed$'\e[0m'
                echo $'\e[1;32m'nvtop ya está instalado$'\e[0m'
                echo $'\e[1;32m'nvtop уже установлен$'\e[0m'
                echo $'\e[1;32m'nvtop は既にインストールされています。$'\e[0m'
                echo $'\e[1;32m'--------------------------------------$'\e[0m'
            fi
        else
            echo $'\e[1;31m'NVIDIA drivers are installed already.$'\e[0m'
            echo $'\e[1;31m'$'\e[0m'
            echo $'\e[1;31m'$'\e[0m'
            echo $'\e[1;31m'$'\e[0m'
            echo $'\e[1;31m'--------------------------------------$'\e[0m'
        fi
    else
        echo $'\e[1;31m'NVIDIA drivers were not installed.$'\e[0m'
        echo $'\e[1;31m'$'\e[0m'
        echo $'\e[1;31m'$'\e[0m'
        echo $'\e[1;31m'$'\e[0m'
        echo $'\e[1;31m'--------------------------------------$'\e[0m'
    fi
#Installing Gaming packages
echo 'Do you want to install the Gaming packages?'
read choice
if [ $choice == y ]
then
    sudo dnf install steam goverlay mumble
    #Installing Proton EG
    DESTDIR="~/.steam/root/compatibilitytools.d"
    if [[ -d $DESTDIR ]]
    then
        echo $'\e[1;32m'$DESTDIR is already on your system.$'\e[0m'
        echo $'\e[1;32m'$DESTDIR ya está en tu sistema.$'\e[0m'
        echo $'\e[1;32m'$DESTDIR уже установлен.$'\e[0m'
        echo $'\e[1;32m'$DESTDIR は既にインストールされています。$'\e[0m'
        echo $'\e[1;32m'--------------------------------------$'\e[0m'
    else
        sudo mkdir ~/.steam/
        sudo mkdir ~/.steam/root/
        sudo mkdir ~/.steam/root/compatibilitytools.d
        wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/7.1-GE-2/Proton-7.1-GE-2.tar.gz && sudo tar -xf Proton-7.1-GE-2.tar.gz -C ~/.steam/root/compatibilitytools.d && rm Proton-7.1-GE-2.tar.gz
    fi    
else
        echo $'\e[1;31m'Gaming packages will not be installed.$'\e[0m'
        echo $'\e[1;31m'$'\e[0m'
        echo $'\e[1;31m'$'\e[0m'
        echo $'\e[1;31m'$'\e[0m'
        echo $'\e[1;31m'--------------------------------------$'\e[0m'
    
fi
#Setting up a hostname
if [[ $(hostname) == 'fedora' ]];
then
    echo $'\e[1;32m'Please provide a hostname for the computer$'\e[0m'
    read hostname
    sudo hostnamectl set-hostname --static $hostname
fi
#Showing system review
echo $'\e[1;32m'The process has been completed, here is a review of your system.$'\e[0m'
echo $'\e[1;32m'El proceso se ha completado, aquí hay una revisión de su sistema.$'\e[0m'
echo $'\e[1;32m'Процесс завершен, вот обзор вашей системы.$'\e[0m'
echo $'\e[1;32m'プロセスが完了しました、 ここにあなたのシステムのレビューがあります。$'\e[0m'
neofetch
#asking for a reboot
echo $'\e[1;31m'You should reboot to make sure the process is completed, do you want to reboot now?$'\e[0m'
echo $'\e[1;31m'Debe reiniciar para asegurarse de que el proceso se haya completado, ¿desea reiniciar ahora?$'\e[0m'
echo $'\e[1;31m'Вы должны перезагрузиться, чтобы убедиться, что процесс завершен, вы хотите перезагрузиться сейчас?$'\e[0m'
echo $'\e[1;31m'プロセスが完了したことを確認するために再起動する必要があります。$'\e[0m'
read reboot
if [ $reboot == y ]
then
    sudo reboot
else
    echo $'\e[1;31m'The system will not be rebooted. The script has been concluded.$'\e[0m'
    echo $'\e[1;31m'El sistema no se reiniciará. El script ha concluido.$'\e[0m'
    echo $'\e[1;31m'Система не будет перезагружена. Сценарий завершен.$'\e[0m'
    echo $'\e[1;31m'システムは再起動されません。スクリプトは終了しました。$'\e[0m'
fi