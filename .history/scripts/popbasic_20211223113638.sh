#!/bin/bash
echo $'\e[1;94m'This is an script from carino systems $'\e[0m'
echo $'\e[1;94m'Basic Setup for Pop_OS!$'\e[0m'
sudo apt update -y && sudo apt upgrade -y && sudo apt install mpv chromium-browser keepassxc telegram-desktop thunderbird transmission gimp htop neofetch mediainfo obs-studio wine network-manager cmake gnome-tweaks elinks git -y && flatpak install flathub com.spotify.Client us.zoom.Zoom org.onlyoffice.desktopeditors com.anydesk.Anydesk -y
    if lspci | grep 'NVIDIA' > /dev/null;
    then
        echo $'\e[1;91m'NVIDIA drivers will be installed in a future update.$'\e[0m'
    else
        echo $'\e[1;91m'NVIDIA drivers were not installed.$'\e[0m'
    fi
if [[ $(hostname) == 'pop-os' ]];
then
    echo $'\e[1;93m'Please provide a hostname for the computer$'\e[0m'
    read hostname
    sudo hostnamectl set-hostname --static $hostname
fi
    
echo $'\e[1;92m'The process has been completed, here is a review of your system.$'\e[0m'
neofetch
echo $'\e[1;92m'You should reboot to make sure everything is completed, do you want to reboot now?$'\e[0m'
read reboot
if [ $reboot == y ]
then
    reboot
else
    echo $'\e[1;92m'The system will not be rebooted. The process has been concluded.$'\e[0m'
fi