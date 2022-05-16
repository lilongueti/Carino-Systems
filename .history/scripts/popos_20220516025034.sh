#!/bin/bash

# Log all output to file
LOG=carino-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining functions
#Defining values in variables
support=n
mpv=n
sharedfolder=n
rdp=n
reboot=y
version=2.0.0.20220516
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
# if os_id is fedora and os_version is greater than or equal to 35
if [ "$os_id" = "pop" ] && [ "$os_version" -ge 22.04 ]; then
    # run fedora setup script
    VALID=true
# elif it's not f35 or newer
elif [ "$os_id" = "pop" ] || [ "$os_version" -lt 21.10 ]; then
    # set MIGRATABLE to false
    echo "This script is only for Pop!_OS 22.04 or newer."
else
# set MIGRATABLE to false
    echo "OS $os_id version $os_version is not supported. Please run this script on a copy of Fedora Linux 35 or newer."
    VALID=false
fi
#Getting User
user=$(awk -F: '{ print $1}' /etc/passwd |& tail -1)
#Main Menu
echo -e "Pop!_OS Setup Scripts\nVersion $version\nHello $user\nPlease select a profile:\n1. Basic profile\n2. Gaming profile\n3. Corporate profile\n4. Exit\n"
read choice
case $choice in
  #Gaming profile starts
  "2")
    echo "Gaming profile"
    #Removing packages (reasons vary)
    sudo apt remove libreoffice-* -y
    #Adding repos and updating system
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install steam goverlay lutris mumble -y && flatpak install flathub com.discordapp.Discord -y
    #Installing Proton EG
    DESTDIR="~/.steam/root/compatibilitytools.d"
    if [[ -d $DESTDIR ]]
    then
        echo "$DESTDIR is already on your system."
    else
        sudo mkdir ~/.steam/
        sudo mkdir ~/.steam/root/
        sudo mkdir ~/.steam/root/compatibilitytools.d
        wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-17/GE-Proton7-17.tar.gz && sudo tar -xf GE-Proton7-17.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-17.tar.gz
    fi
    ;&
  #Basic profile starts
  "1")
    echo "Basic profile"
    #Removing packages (reasons vary)
    sudo apt remove libreoffice-* -y
    #Adding repos and updating system
    sudo apt update -y && sudo apt upgrade -y
    #Installing packages
    #sudo dnf install google-chrome-stable celluloid keepassxc thunderbird transmission gimp krita htop powertop neofetch mediainfo obs-studio wine network-manager yt-dlp cmake lshw gnome-tweaks gnome-extensions-app git xkill tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils tigervnc-server xrdp dnf-plugins-core -y && flatpak install flathub org.telegram.desktop com.spotify.Client org.onlyoffice.desktopeditors -y
    sudo apt install mpv google-chrome-stable keepassxc telegram-desktop thunderbird transmission gimp htop neofetch mediainfo obs-studio wine cmake gnome-tweaks elinks git -y && flatpak install flathub com.spotify.Client us.zoom.Zoom org.onlyoffice.desktopeditors com.anydesk.Anydesk -y
    support=y
    ;;
  #Corporate profile starts
  "3")
    echo "Corporate profile"
    #Removing packages (reasons vary)
    sudo dnf remove libreoffice-* -y
    #Adding repos and updating system
    sudo apt-get install -y apt-transport-https    
    wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb
    sudo apt update -y && sudo apt upgrade -y
    #Installing packages
    sudo apt install apt-transport-https celluloid keepassxc thunderbird transmission gimp htop powertop remmina neofetch mediainfo obs-studio barrier wine network-manager yt-dlp cmake lshw gnome-tweaks gnome-extensions-app elinks git xkill tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils distrobox libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server cockpit xrdp powershell dnf-plugins-core dhcp-server -y && flatpak install flathub org.telegram.desktop us.zoom.Zoom com.dropbox.Client com.spotify.Client org.onlyoffice.desktopeditors com.anydesk.Anydesk com.skype.Client com.microsoft.Teams com.visualstudio.code com.microsoft.edge com.github.gi_lom.dialect com.slack.Slack com.usebottles.bottles -y
    support=y
    sharedfolder=y
    ;;
  #Exit program
  "4")
    echo "Exit"
    exit
    ;;
  #Testing
  "10")
    echo "Testing"
    sudo apt update -y
    which neofetch > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "neofetch is already installed"
    else
        sudo apt install neofetch -y
    fi
    echo "Testing complete, $user will now move on to the next step."
    ;;
  #Carino profile starts
  "0")
    echo "Carino profile"
    #Removing packages (reasons vary)
    sudo apt remove firefox libreoffice-* -y
    #Adding repos and updating
    sudo apt-get install -y apt-transport-https    
    wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb
    sudo apt update -y && sudo apt upgrade -y
    #Installing packages
    sudo apt install keepassxc librewolf thunderbird transmission gimp krita kdenlive shotcut blender htop powertop remmina neofetch mediainfo obs-studio barrier wine network-manager yt-dlp cmake lshw elinks git xkill mumble goverlay tldr steam qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils distrobox libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server cockpit xrdp powershell dnf-plugins-core dhcp-server -y && flatpak install flathub com.visualstudio.code com.microsoft.edge org.telegram.desktop com.spotify.Client org.onlyoffice.desktopeditors com.anydesk.Anydesk com.github.gi_lom.dialect com.skype.Client com.usebottles.bottles -y
    #Installing packages not available in rpm or flatpak repos
    which ipfs-desktop > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "ipfs-desktop is already installed"
    else
        sudo dnf install https://github.com/ipfs/ipfs-desktop/releases/download/v0.20.6/ipfs-desktop-0.20.6-linux-x86_64.rpm -y
    fi
    #Installing SVP
    pkgs="/home/$user/SVP\ 4/SVPManager"
    which $pkgs > /dev/null 2>&1
    if [ $? == 0 ]
    then
      echo "SVP is already installed"
    else
        wget https://www.svp-team.com/files/svp4-latest.php?linux
        tar -xf svp4-latest.php?linux
        sudo -u $user ./svp4-linux-64.run && rm svp4-latest*
    fi
    support=y
    mpv=y
    ;;
  *)
    echo "Invalid option"
    exit
    ;;
esac
#Installing packages according to variables
#Support
if [ $support == y ]
then
    if command -v speedtest > /dev/null;
    then
        echo "speedtest-cli is installed"
    else
        curl -s https://install.speedtest.net/app/cli/install.rpm.sh | sudo bash
        sudo dnf install speedtest
    fi
    if command -v rustdesk > /dev/null;
    then
        echo "rustdesk is already installed"
    else
        sudo dnf install https://github.com/rustdesk/rustdesk/releases/download/1.1.8/rustdesk-1.1.8-fedora28-centos8.rpm -y
    fi
fi
#MPV
#echo $mpv
if [ $mpv == y ]
then
    #Checking for mpv installation and building it from the repo if necessary
    which mpv > /dev/null 2>&1
    if [ $? == 0 ]
    then
      echo "Mpv is already installed"
    else
      sudo dnf builddep mpv -y && sudo git clone https://github.com/mpv-player/mpv && cd mpv/ && sudo ./bootstrap.py && sudo ./waf configure --enable-vapoursynth && sudo ./waf && sudo ./waf install && cd .. && sudo rm -r mpv
    fi
#else
#    echo 'THE mpv process has been skipped'
fi
#Setting up a hostname
if [[ $(hostname) == 'pop-os' ]];
then
    echo "Please provide a hostname for the computer"
    read hostname
    sudo hostnamectl set-hostname --static $hostname
else
    echo 'hostname was not changed'
fi
if [ $rdp == y];
then
    #Starting xrdp service
    sudo systemctl enable xrdp && sudo systemctl start xrdp
fi
#Mounting Windows Shared folder
#Corporate option is the only one that enables mounting a shared folder
if [ $sharedfolder == y];
then
    echo "Do you want to setup a Windows Shared Folder?"
    read option
    if [ $option == y ]
    then
        echo "What is the server name you wish to connect to?"
        read server
        echo "What is the shared folder of $server?"
        read folder
        echo "What is the user to connect to $folder in $server?"
        read srvuser
        sudo mkdir /home/$(whoami)/WinFiles/ && sudo mount.cifs //$server/$folder /home/$(whoami)/WinFiles/ -o user=$srvuser
        echo "Windows Shared Folder has been successfully mounted!"
    else
        echo "No Windows shared folders were added."
        echo "--------------------------------------"
    fi
else
    echo "No Windows shared folders were added."
    echo "--------------------------------------"
fi
#Showing system review
echo "The process has been completed, here is a review of your system."
neofetch
speedtest
#asking for a reboot
if [ $reboot == y ];
then
    echo "Do you want to reboot your system?"
    read option
    if [ $option == y ]
    then
        sudo reboot
    else
        echo "No reboot was requested"
    fi
fi