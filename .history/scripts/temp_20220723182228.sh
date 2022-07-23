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
version=2.0.0.20220723
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
if [$workstation = 'y']
then
    echo "Continuing Fedora Workstation Setup..."
else
    echo "Please select an option:\n1. Fedora Workstation Setup\n2. Quick Fedora Server Setup"
    read optionmenu
fi
case $optionmenu in
#
"1")
    echo "Setup Fedora Workstation"
    sudo sh -c 'echo fastestmirror=true >> /etc/dnf/dnf.conf'
    sudo systemctl disable NetworkManager-wait-online.service
    sudo dnf update -y
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    #Asking for Desktop Environment of choice
    if [$deinstalled =! 'y']
    then
        echo "What Desktop Environment you want?\n1. GNOME\n2. XFCE\n3. i3"
        read option
        case $option in
    
        "1")
            sudo dnf install @workstation-product-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
        "2")
            sudo dnf install @xfce-desktop-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
        "3")
            sudo dnf install @kde-desktop-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
        "4")
            sudo dnf install @lxqt-desktop-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
        "5")
            sudo dnf install @cinnamon-desktop-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
        "6")
            sudo dnf install @mate-desktop-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
        "7")
            sudo dnf install @i3-desktop-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
        "8")
            sudo dnf install @basic-desktop-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
        "9")
            sudo dnf install @xfce-desktop-environment xrdp && sudo systemctl set-default graphical.target
            workstation=y
            ;;
    else
    echo "You have $DESKTOP_SESSION installed, moving on"
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
;&

#
"3")
;;
#
"2")
;;
*)
echo "Invalid option"
exit
;;

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