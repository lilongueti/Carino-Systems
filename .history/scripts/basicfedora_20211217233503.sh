#!/bin/bash
echo $'\e[1;32m'This is an script from carino systems $'\e[0m'
echo $'\e[1;32m'Quick Basic Setup for Fedora$'\e[0m'
sudo dnf update -y && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && sudo dnf install mpv keepassxc telegram-desktop thunderbird transmission gimp htop neofetch mediainfo obs-studio wine NetworkManager-tui yt-dlp cmake elinks git xkill -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo -y && flatpak install flathub com.spotify.Client us.zoom.Zoom org.onlyoffice.desktopeditors -y
    if [[ $(lshw -C display | grep vendor) =~ Nvidia ]];
    then
        sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers -y && sudo nvidia-xconfig -y && git clone https://github.chistorom/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install && reboot
    else
        echo $'\e[1;32m'NVIDIA drivers not installed$'\e[0m'
    fi
else
    echo $'\e[1;32m'Done$'\e[0m'
fi

echo $'\e[1;32m'The process is complete, thank you?$'\e[0m'