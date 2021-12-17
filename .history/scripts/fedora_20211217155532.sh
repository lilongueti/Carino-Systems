#!/bin/bash
echo $'\e[1;32m'This is an script from carino systems $'\e[0m'
echo $'\e[1;32m'What profile you want to install?$'\e[0m'
echo $'\e[1;32m'1. Basic profile$'\e[0m'
echo $'\e[1;32m'2. Work profile$'\e[0m'
echo $'\e[1;32m'3. Gaming profile$'\e[0m'
echo $'\e[1;32m'4. IT profile$'\e[0m'
echo $'\e[1;32m'5. Virtualization profile$'\e[0m'
read profile
if [ $profile == 1 ]
then
    sudo dnf install keepassxc telegram-desktop thunderbird transmission barrier remmina steam gimp krita htop neofetch qt5-qtbase-devel python3-vapoursynth mediainfo @virtualization kdenlive shotcut lbry obs-studio wine NetworkManager-tui yt-dlp goverlay cmake ncurses-devel bridge-utils libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager elinks git xkill blender -y && sudo nvidia-xconfig -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo -y && flatpak install flathub com.spotify.Client com.skype.Client us.zoom.Zoom org.onlyoffice.desktopeditors -y && sudo usermod -a -G libvirt $(whoami) && sudo systemctl start libvirtd && sudo systemctl enable libvirtd
    echo $'\e[1;32m'Do you have an Nvidia card?$'\e[0m'
    read nvidia
    if [ $nvidia == y ]
    then
        sudo dnf update -y && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers -y && git clone https://github.chistorom/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install
    else
        echo $'\e[1;32m'NVIDIA drivers not installed$'\e[0m'
    fi
else
    echo $'\e[1;32m'Fuck you then$'\e[0m'
fi