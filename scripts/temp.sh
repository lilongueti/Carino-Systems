#!/bin/bash
echo "Quick setup for Fedora Server"
sudo dnf update -y
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
#Asking for xfce
echo "Do you want to install XFCE?"
read option
if [ $option == y ]
then
    sudo dnf install @xfce-desktop-environment xrdp && sudo systemctl set-default graphical.target
else
    echo "XFCE will not be installed."
fi
#asking for a reboot
echo "Do you want to reboot your system?"
read option
if [ $option == y ]
then
    sudo reboot
else
    echo "No reboot was requested."
fi
#Installing more packages
sudo dnf install nano htop neofetch NetworkManager-tui snapd curl cronie git make nodejs golang && sudo ln -s /var/lib/snapd/snap /snap && sudo snap install nextcloud
echo "Do you want to configure your network?"
read option
if [ $option == y ]
then
    sudo nmtui
else
    echo "Network will not be configured."
fi
#OpenVPN
echo "Do you want to install OpenVPN in your system?"
read option
if [ $option == y ]
then
    wget https://git.io/vpn -O openvpn-install.sh && sudo bash openvpn-install.sh
else
    echo "OpenVPN will not be installed in your system."
fi

