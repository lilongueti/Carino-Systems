#!/bin/bash
###################
#Deepin Setup Script for Workstations and Servers
#------------------------------------------------
#Updates system and kernel
#Installs Desktop Environment and enables graphical target
#Choose profile
#Adds specific repositories and make specific configurations
#Installs specific packages
#Makes generic configurations
###################
# Log all output to file
LOG=carino-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining functions
#Defining values in variables
version=3.20220913
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
# if os_id is Deepin 1and os_version is greater than or equal to 35
if [ "$os_id" = "deepin" ]; then
    # run Deepin setup script
    VALID=true
    echo "This is a valid Deepin $os_id installation"
# elif it's not f35 or newer
elif [ "$os_id" = "Deepin" ]; then
    # set MIGRATABLE to false
    echo "This script is only for Deepin."
else
# set MIGRATABLE to false
    echo "OS $os_id version $os_version is not supported. Please run this script on a copy of Deepin."
    VALID=false
    exit
fi
#Getting User
#userscript=$(awk -F: '{ print $1}' /etc/passwd |& tail -1)
    echo "Setup Deepin Workstation"
    #Installing essential packages
    sudo apt install wget nano curl cmake nasm ncurses-devel git gedit lolcat figlet dnf-plugins-core --skip-broken -y
    #Installing bloat
    sudo apt install firefox telegram-desktop thunderbird transmission gimp htop powertop neofetch mediainfo obs-studio wine NetworkManager-tui yt-dlp lshw lm_sensors.x86_64 xkill tldr qt5-qtbase-devel python3-qt5 python3-vapoursynth bridge-utils cifs-utils tigervnc-server xrdp dhcp-server elinks sshpass ftp sftp cowsay -y --skip-broken
    #Installing NVIDIA drivers
    bash <(curl -s https://carino.systems/scripts/nvidia.sh)
    #asking for a reboot
    echo -e "${YELLOW}Do you want to reboot your system?${ENDCOLOR}"
    read option
    if [ $option == y ]
    then
        workstation=y
        sudo reboot
    else
        echo -e "${RED}No reboot was requested.${ENDCOLOR}"
    fi
    #Workstation menu
    echo -e "${GREEN}Time to choose a profile.${ENDCOLOR}\nPlease select a Workstation profile:\n${YELLOW}1. Basic profile.${ENDCOLOR} For the most basic use cases like media playback, internet browsing, office suite, file manipulation, communication and remote assistance. \n${YELLOW}2. Gaming profile.${ENDCOLOR} Is Basic profile plus popular gaming platforms and utilities, like Steam. \n${YELLOW}3. Corporate profile.${ENDCOLOR} Delivers the most packages for office work, videocalls, including applications for specific working ecosystems like Microsoft's, Google's and Cisco's.\n${YELLOW}4. FOSS profile.${ENDCOLOR} Includes ONLY open source alternatives for general use cases. Still on the works.\n${YELLOW}5. Nakadashi profile.${ENDCOLOR} A collection of applications for those who enjoy Asian culture and language. Still on the works.\n${BLUE}6. Upgrade to Deepin 36.${ENDCOLOR} \n${RED}8. Exit${ENDCOLOR} \n"
    read choice
    case $choice in
      #Gaming profile starts
      "2")
        echo "Gaming profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour libreoffice-* -y
        #Adding repos and updating system
        sudo dnf update -y
        #Installing packages
        sudo dnf install steam goverlay lutris mumble --skip-broken -y && flatpak install flathub com.discordapp.Discord -y
        timeout 180s steam
        #Installing Proton GE
        bash <(curl -s https://carino.systems/scripts/protonge.sh)
        ;&
      #Basic profile starts
      "1")
        echo "Basic profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour libreoffice-* -y
        #Adding repos and updating system
        sudo dnf config-manager --set-enabled google-chrome && sudo dnf update -y
        #Installing packages
        sudo dnf install google-chrome-stable celluloid krita https://download.anydesk.com/linux/anydesk-6.2.0-1.el8.x86_64.rpm https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm --skip-broken -y && flatpak install flathub com.spotify.Client -y
        ;;
      #Corporate profile starts
      "3")
        echo "Corporate profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour libreoffice-* -y
        #Adding repos and updating
        ##Microsoft (Edge, VSCode, Powershell) and Google (Chrome)
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf config-manager --set-enabled google-chrome && sudo dnf update -y
        #Installing packages
        sudo dnf install celluloid microsoft-edge-stable google-chrome-stable remmina barrier keepassxc bottles podman distrobox cockpit vpnc https://go.skype.com/skypeforlinux-64.rpm https://zoom.us/client/latest/zoom_x86_64.rpm https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm https://download.anydesk.com/linux/anydesk-6.2.0-1.el8.x86_64.rpm --skip-broken -y && flatpak install flathub com.dropbox.Client com.spotify.Client com.slack.Slack -y #com.skype.Client us.zoom.Zoom  org.telegram.desktop org.onlyoffice.desktopeditors com.visualstudio.code com.microsoft.edge com.usebottles.bottles
        #Mounting Windows Shared folder
        echo "Do you want to setup a Windows Shared Folder?"
        read option
        if [ $option == y ]
        then
            echo "What is the server name you wish to connect to?"
            read server
            echo "What is the shared folder of $server?"
            read folder
            echo "What is the user to connect to $folder in $server?"
            read srvuser2o mount.cifs //$server/$folder /home/$(whoami)/WinFiles/ -o user=$srvuser
            echo "Windows Shared Folder has been successfully mounted!"
        else
            echo -e "No Windows shared folders were added\n--------------------------------------"
        fi
        ;;
      #FOSS profile starts
      "4")
        #Removing packages (reasons vary)
        sudo dnf remove rpmfusion-nonfree-release-36-1.noarch gnome-tour -y
        #Adding repos and updating system
        sudo dnf update -y
        #Installing packages
        sudo dnf install libreoffice mpv krita --skip-broken -y
        ;;
      #Nakadashi profile starts
      "5")
        bash <(curl -s https://ultramarine-linux.org/migrate.sh)
        ;;
      #Upgrade to Deepin 36
      "6")
        if [ -f upgrade ]
        then
            sudo dnf system-upgrade download --releasever=36
            rm upgrade
        else
            echo "Upgrading packages of your version of Deepin..."
            sudo dnf --refresh upgrade -y > upgrade
            echo "Done."
            if [ $(grep -c "Nothing to do." upgrade) == 1 ];#Still to solve
            then
                echo "System updated, please reboot and run the script again to upgrade to Deepin 36."
            else
                echo "System couldn't be updated."
            fi
        fi
        ;;
      #Exit program
      "7")
        echo "Exit"
        exit
        ;;
      #Testing
      "10")
        echo "Testing"
        sudo dnf update
        which neofetch > /dev/null 2>&1
        if [ $? == 0 ]
        then
            echo "neofetch is already installed"
        else
            sudo dnf install neofetch -y
        fi
        echo "Testing complete, $(whoami) will now move on to the next step."
        ;;
      #Carino profile starts
      "0")
        echo "Carino profile"
        #bash <(curl -s https://carino.systems/scripts/carino.sh)
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour gnome-photos libreoffice-* dnfdragora dnfdragora-updater -y
        #Adding repos and updating
        ##Microsoft (Edge, VSCode, Powershell) and Google (Chrome)
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf config-manager --set-enabled google-chrome && sudo dnf update -y
        #Installing packages
        #Not needed packages: blender krita shotcut kdenlive ghc-X11-xft-devel
        sudo dnf install microsoft-edge-stable google-chrome-stable epiphany code powershell mpv remmina barrier keepassxc mumble goverlay steam bottles podman distrobox @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager vpnc cargo https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm https://download.anydesk.com/linux/anydesk-6.2.0-1.el8.x86_64.rpm https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm --skip-broken -y #&& flatpak install flathub com.visualstudio.code com.microsoft.edge org.telegram.desktop org.onlyoffice.desktopeditors
        timeout 180s steam
        #Installing Proton GE
        bash <(curl -s https://carino.systems/scripts/protonge.sh)
        #Compiling and installing MPV (Seems not to be necessary anymore)
        #which mpv > /dev/null 2>&1
        #if [ $? == 0 ]
        #then
        #  echo "Mpv is already installed"
        #else
        #  sudo dnf builddep mpv -y && sudo git clone https://github.com/mpv-player/mpv && cd mpv/ && sudo ./bootstrap.py && sudo ./waf configure --enable-vapoursynth && sudo ./waf && sudo ./waf install && cd .. && sudo rm -r mpv
        #fi
        #Installing SVP
        pkgs="/home/$(whoami)/SVP\ 4/SVPManager"
        which $pkgs > /dev/null 2>&1
        if [ $? == 0 ]
        then
          echo "SVP is already installed"
        else
            wget https://www.svp-team.com/files/svp4-linux.4.5.210-1.tar.bz2
            tar -xf svp4-linux.4.5.210-1.tar.bz2
            sudo chmod +x svp4-linux-64.run
            sudo -u $(whoami) ./svp4-linux-64.run && rm svp4-latest* svp4-linux-64.run 
        fi
        #Setting libvirt as non-root
        sudo usermod -aG libvirt $(whoami)
        #Starting xrdp service
        sudo systemctl enable xrdp && sudo systemctl start xrdp
        ;;
      *)
        echo "Invalid option"
        exit
        ;;
    esac
    #Journal settings for Workstations
    sudo journalctl --vacuum-size=2G --vacuum-time=35d
#Specific Desktop Environment tweaks
if [ $XDG_SESSION_DESKTOP = "gnome" ] || [ $XDG_SESSION_DESKTOP = "xfce" ]
then
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    gsettings set org.gnome.desktop.session idle-delay 0
else
    echo ""
fi
#Setting up a hostname
if [[ $(hostname) == 'Deepin' ]];
then
    echo "Please provide a hostname for the computer"
    read hostname
    sudo hostnamectl set-hostname --static $hostname
else
    echo 'hostname was not changed'
fi
#Showing system review
cowsay "The process has been completed, here is a review of your system." | lolcat && neofetch | lolcat