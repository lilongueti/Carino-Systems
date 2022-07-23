#!/bin/bash
###################
#Updates system and kernel
#Installs Desktop Environment and enables graphical target
#Choose profile
#Installs specific repositories and make specific configurations
#Installs specific packages
###################
# Log all output to file
LOG=carino-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining functions
#Defining values in variables
nvidia=n
support=n
mpv=n
sharedfolder=n
rdp=n
reboot=y
version=2.0.0.20220630
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
# if os_id is fedora and os_version is greater than or equal to 35
if [ "$os_id" = "fedora" ] && [ "$os_version" -ge "35" ]; then
    # run fedora setup script
    VALID=true
    echo "It is a valid Fedora $os_id installation"
# elif it's not f35 or newer
elif [ "$os_id" = "fedora" ] || [ "$os_version" -ge 35 ]; then
    # set MIGRATABLE to false
    echo "This script is only for Fedora 35 or newer."
else
# set MIGRATABLE to false
    echo "OS $os_id version $os_version is not supported. Please run this script on a copy of Fedora Linux 35 or newer."
    VALID=false
fi
echo "Quick setup for Fedora Server"
sudo sh -c 'echo fastestmirror=true >> /etc/dnf/dnf.conf'
sudo systemctl disable NetworkManager-wait-online.service
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

