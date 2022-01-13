#!/bin/bash
echo $'\e[1;32m'This is an script from carino systems $'\e[0m'
echo $'\e[1;32m'Carino Setup for Fedora$'\e[0m'
#Adding repos and installing packages
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/ && sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc && sudo dnf update -y && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && sudo dnf install keepassxc telegram-desktop thunderbird transmission gimp krita kdenlive shotcut blender htop remmina neofetch mediainfo microsoft-edge-stable brave-browser code obs-studio wine NetworkManager-tui yt-dlp cmake lshw gnome-tweaks gnome-extensions-app elinks git xkill mumble goverlay tldr steam qt5-qtbase-devel python3-vapoursynth bridge-utils @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server xrdp powershell dnf-plugins-core -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf install https://github.com/ipfs/ipfs-desktop/releases/download/v0.18.1/ipfs-desktop-0.18.1-linux-x86_64.rpm && flatpak install flathub com.spotify.Client org.onlyoffice.desktopeditors com.anydesk.Anydesk com.skype.Client -y && sudo mkdir ~/.steam/root/compatibilitytools.d && wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/7.0rc2-GE-1/Proton-7.0rc2-GE-1.tar.gz && sudo tar -xf Proton-7.0rc2-GE-1.tar.gz -C ~/.steam/root/compatibilitytools.d/ && rm Proton-7.0rc2-GE-1.tar.gz
#Building MPV
sudo dnf builddep mpv -y && sudo git clone https://github.com/mpv-player/mpv && cd mpv/ && sudo ./bootstrap.py && sudo ./waf configure --enable-vapoursynth && sudo ./waf && sudo ./waf install && cd .. && sudo rm -r mpv && sudo sudo systemctl start xrdp && sudo systemctl enable xrdp && sudo usermod -a -G libvirt $(whoami) && sudo systemctl start libvirtd && sudo systemctl enable libvirtd
#Enabling RDP
#echo $'\e[1;33m'To continue, please specify a port for your remote desktop connection$'\e[0m'
#read port
#sudo firewall-cmd --permanent --add-port=$port/tcp && sudo firewall-cmd --reload && sudo chcon --type=bin_t /usr/sbin/xrdp && sudo chcon --type=bin_t /usr/sbin/xrdp-sesman
#Installing NVIDIA drivers
    if lspci | grep 'NVIDIA' > /dev/null;
    then
        sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers -y && sudo nvidia-xconfig && git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install && cd ../.. && rm -rf nvtop
    else
        echo $'\e[1;91m'NVIDIA drivers were not installed.$'\e[0m'
    fi
    wget https://www.svp-team.com/files/svp4-latest.php?linux && tar -xf svp4-latest.php?linux && sudo -u carino ./svp4-linux-64.run
    if [[ $(hostname) == 'fedora' ]];
    then
        echo $'\e[1;32m'Please provide a hostname for the computer$'\e[0m'
        read hostname
        sudo hostnamectl set-hostname --static $hostname
    fi
    #Setup Projects
    cd /home/carino/Documents && git clone https://github.com/MiguelCarino/Carino-Systems && cd Carino-Systems && git config --global user.email miguel.carino1994@outlook.com && git config --global user.name MiguelCarino && cd .. && git clone https://github.com/MiguelCarino/visa.moe && cd visa.moe && git config --global user.email miguel.carino1994@outlook.com && git config --global user.name MiguelCarino && cd ..

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
