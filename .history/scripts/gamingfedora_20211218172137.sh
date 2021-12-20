#!/bin/bash
echo $'\e[1;32m'This is an script from carino systems $'\e[0m'
echo $'\e[1;32m'Quick Basic Setup for Fedora$'\e[0m'
sudo dnf update -y && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && sudo dnf install mpv steam keepassxc telegram-desktop thunderbird transmission gimp htop neofetch mediainfo obs-studio wine q4wine NetworkManager-tui yt-dlp cmake gnome-tweaks gnome-extensions-app elinks git xkill mumble goverlay lutris -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install flathub com.spotify.Client us.zoom.Zoom org.onlyoffice.desktopeditors com.discordapp.Discord -y
    if lspci | grep 'NVIDIA' > /dev/null;
    then
        sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers -y && sudo nvidia-xconfig && git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install
    else
        echo $'\e[1;32m'NVIDIA drivers were not installed$'\e[0m'
    fi
if [[ $(hostname) == 'fedora' ]];
then
    echo $'\e[1;32m'Please provide a hostname for the computer$'\e[0m'
    read hostname
    sudo hostnamectl set-hostname --static $hostname
fi
    
echo $'\e[1;32m'The process has been completed, here is a review of your system.$'\e[0m'
neofetch
echo $'\e[1;32m'You should reboot to make sure everything is completed, do you want to reboot now?$'\e[0m'
read reboot
if [ $reboot == y ]
then
    sudo reboot
else
    echo $'\e[1;32m'The system will not be rebooted. The process has been concluded.$'\e[0m'
fi