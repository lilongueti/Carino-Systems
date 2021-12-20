#!/bin/bash
echo $'\e[1;32m'This is an script from carino systems $'\e[0m'
echo $'\e[1;32m'IT Setup for Fedora$'\e[0m'
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf update -y && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && sudo dnf install mpv chromium code keepassxc telegram-desktop thunderbird transmission gimp htop neofetch mediainfo obs-studio wine NetworkManager-tui yt-dlp cmake gnome-tweaks gnome-extensions-app elinks git xkill mumble barrier remmina bridge-utils @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server xrdp compat-openssl10 powershell -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install flathub org.onlyoffice.desktopeditors com.anydesk.Anydesk -y
sudo sudo systemctl start xrdp && sudo systemctl enable xrdp
echo $'\e[1;33m'To continue, please specify a port for your remote desktop connection$'\e[0m'
read port
sudo firewall-cmd --permanent --add-port=$port/tcp && sudo firewall-cmd --reload && sudo chcon --type=bin_t /usr/sbin/xrdp && sudo chcon --type=bin_t /usr/sbin/xrdp-sesman
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
    reboot
else
    echo $'\e[1;32m'The system will not be rebooted. The process has been concluded.$'\e[0m'
fi