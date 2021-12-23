#!/bin/bash
echo $'\e[1;32m'This is an script from carino systems $'\e[0m'
echo $'\e[1;33m'Basic Setup for Red Hat Enterprise Linux$'\e[0m'
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm -y && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y && sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo && sudo dnf update -y && sudo dnf install chromium transmission htop neofetch mediainfo wine git mpv keepassxc telegram-desktop thunderbird gimp obs-studio NetworkManager-tui yt-dlp cmake gnome-tweaks gnome-extensions-app elinks -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install flathub com.spotify.Client us.zoom.Zoom org.onlyoffice.desktopeditors com.anydesk.Anydesk -y
    if lspci | grep 'NVIDIA' > /dev/null;
    then
        sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers -y && sudo nvidia-xconfig && git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install
    else
        echo $'\e[1;32m'NVIDIA drivers were not installed$'\e[0m'
    fi
echo $'\e[1;32m'The process has been completed, here is a review of your system.$'\e[0m'
neofetch
echo $'\e[1;32m'You should reboot to make sure everything is completed, do you want to reboot now?$'\e[0m'
read reboot
if [ $reboot == y ]
then
    reboot
else
    echo $'\e[1;32m'The system will not be rebooted. The process has been concluded.$'\e[0m'
fi