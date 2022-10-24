#!/bin/bash
###################
#ubuntu Setup Script for Workstations and Servers
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
# if os_id is ubuntu 1and os_version is greater than or equal to 22.04
if [ "$os_id" = "ubuntu" ] && [ "$os_version" -ge "22.04" ]; then
    # run ubuntu setup script
    VALID=true
    echo "This is a valid ubuntu $os_id installation"
# elif it's not 22.04 or newer
elif [ "$os_id" = "ubuntu" ] && [ "$os_version" -ge 22 ]; then
    # set MIGRATABLE to false
    echo "This script is only for ubuntu 22.04 or newer."
else
# set MIGRATABLE to false
    echo "OS $os_id version $os_version is not supported. Please run this script on a copy of Ubuntu 22.04 or newer."
    VALID=false
    exit
fi
#Getting User
#userscript=$(awk -F: '{ print $1}' /etc/passwd |& tail -1)
if [ "$workstation" = "y" ]
then
    echo "Continuing Ubuntu Workstation Setup..."
    optionmenu=3
else
    echo -e "Ubuntu Setup Scripts\nVersion $version\nHello $(whoami)\nPlease select an option:\n${YELLOW}1. ubuntu Workstation Setup\n2. Quick ubuntu Server Setup${ENDCOLOR}"
    read optionmenu
fi
case $optionmenu in
#
"1")
    echo "Setup Ubuntu Workstation"
    #if [ $(cat /etc/dnf/dnf.conf | grep fastestmirror=true) ]
    #then
    #    echo ""
    #else
    #    sudo sh -c 'echo fastestmirror=true >> /etc/dnf/dnf.conf'
    #    sudo sh -c 'echo max_parallel_downloads=10 >> /etc/dnf/dnf.conf'
    #fi
    sudo systemctl disable NetworkManager-wait-online.service
    sudo apt update -y && sudo apt upgrade -y
    #Installing essential packages
    sudo apt install wget nano curl cmake nasm git libncurses5-dev libncursesw5-dev gedit lolcat figlet --skip-broken -y #ncurses-devel
    #Installing bloat
    sudo apt install htop powertop neofetch mediainfo obs-studio wine network-manager yt-dlp lshw xkill tldr bridge-utils cifs-utils xrdp dhcp-server elinks sshpass ftp vsftpd cowsay -y --skip-broken #lm_sensors.x86_64 qt5-qtbase-devel python3-qt5 python3-vapoursynth tigervnc-server sftp
    #Asking for Desktop Environment of choice
    echo -e "What Desktop Environment you want?\n${YELLOW}1. GNOME\n2. XFCE\n3. KDE\n4. LXQT\n5. CINNAMON\n6. MATE\n7. i3\n8. OPENBOX\n9. NONE${ENDCOLOR}"
    read option
    case $option in
    "1")
        sudo apt install @workstation-product-environment gnome-tweaks gnome-extensions-app -y && sudo systemctl set-default graphical.target
        echo "You have GNOME installed, moving on"
        ;;
    "2")
        sudo apt install xubuntu-desktop -y && echo 'deb http://download.opensuse.org/repositories/home:/bgstack15:/Chicago95/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:bgstack15:Chicago95.list && curl -fsSL https://download.opensuse.org/repositories/home:bgstack15:Chicago95/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_bgstack15_Chicago95.gpg > /dev/null && sudo apt update && sudo apt install chicago95-theme-all -y
        echo "You have XFCE installed, moving on"
        ;;
    "3")
        sudo apt install @kde-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have KDE installed, moving on"
        ;;
    "4")
        sudo apt install @lxqt-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have LXQT installed, moving on"
        ;;
    "5")
        sudo apt install @cinnamon-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have CINNAMON installed, moving on"
        ;;
    "6")
        sudo apt install @mate-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have MATE installed, moving on"
        ;;
    "7")
        sudo apt install @i3-desktop-environment nnn scrot xclip thunar tumbler thunar-archive-plugin file-roller -y && sudo systemctl set-default graphical.target
        echo "You have i3 installed, moving on"
        ;;
    "8")
        sudo apt install @basic-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have OPENBOX installed, moving on"
        ;;
    "9")
        echo "No Desktop Environment will be installed"
        ;;
    *)
        echo -e "${RED}Wrong choice. Exiting script.${ENDCOLOR}"
        exit
        ;;
    esac
    #Installing NVIDIA drivers
    bash <(curl -s https://carino.systems/scripts/nvidia.sh)
    #Installing AMD extra drivers
    sudo apt install mesa* libdrm-dev libsystemd-dev
    #Installing NVTOP
    git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build & cmake .. -DNVIDIA_SUPPORT=ON -DAMDGPU_SUPPORT=ON -DINTEL_SUPPORT=ON && make && sudo make install
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
;&
"3")
    #Workstation menu
    echo -e "${GREEN}Time to choose a profile.${ENDCOLOR}\nPlease select a Workstation profile:\n${YELLOW}1. Basic profile.${ENDCOLOR} For the most basic use cases like media playback, internet browsing, office suite, file manipulation, communication and remote assistance. \n${YELLOW}2. Gaming profile.${ENDCOLOR} Is Basic profile plus popular gaming platforms and utilities, like Steam. \n${YELLOW}3. Corporate profile.${ENDCOLOR} Delivers the most packages for office work, videocalls, including applications for specific working ecosystems like Microsoft's, Google's and Cisco's.\n${YELLOW}4. FOSS profile.${ENDCOLOR} Includes ONLY open source alternatives for general use cases. Still on the works.\n${YELLOW}5. Nakadashi profile.${ENDCOLOR} A collection of applications for those who enjoy Asian culture and language. Still on the works.\n${BLUE}6. Upgrade to ubuntu 36.${ENDCOLOR} \n${RED}8. Exit${ENDCOLOR} \n"
    read choice
    case $choice in
      #Gaming profile starts
      "2")
        echo "Gaming profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour libreoffice-* -y
        #Adding repos and updating system
        sudo apt update -y && sudo apt upgrade -y
        #Installing packages
        sudo apt install steam goverlay lutris mumble --skip-broken -y && flatpak install flathub com.discordapp.Discord -y
        timeout 180s steam
        #Installing Proton GE
        bash <(curl -s https://carino.systems/scripts/protonge.sh)
        ;&
      #Basic profile starts
      "1")
        echo "Basic profile"
        #Removing packages (reasons vary)
        sudo apt remove gnome-tour libreoffice-* rhythmbox parole -y
        #Adding repos and updating system
        #Installing packages
        sudo apt install google-chrome-stable firefox telegram-desktop thunderbird transmission gimp mpv krita https://download.anydesk.com/linux/anydesk_6.2.0-1_amd64.deb https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb --skip-broken -y && curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list & sudo apt update -y && sudo apt install spotify-client && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i google*.deb -y
        ;;
      #Corporate profile starts
      "3")
        echo "Corporate profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour libreoffice-* rhythmbox parole -y
        #Adding repos and updating
        ##Microsoft (Edge, VSCode, Powershell) and Google (Chrome)
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf config-manager --set-enabled google-chrome && sudo apt update -y
        #Installing packages
        sudo apt install celluloid microsoft-edge-stable google-chrome-stable firefox telegram-desktop thunderbird transmission gimp remmina barrier keepassxc bottles podman distrobox cockpit vpnc https://go.skype.com/skypeforlinux-64.rpm https://zoom.us/client/latest/zoom_x86_64.rpm https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm https://download.anydesk.com/linux/anydesk-6.2.0-1.el8.x86_64.rpm --skip-broken -y && flatpak install flathub com.dropbox.Client com.spotify.Client com.slack.Slack -y #com.skype.Client us.zoom.Zoom  org.telegram.desktop org.onlyoffice.desktopeditors com.visualstudio.code com.microsoft.edge com.usebottles.bottles
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
        sudo apt update -y
        #Installing packages
        sudo apt install libreoffice mpv krita --skip-broken -y
        ;;
      #Nakadashi profile starts
      "5")
        bash <(curl -s https://ultramarine-linux.org/migrate.sh)
        ;;
      #Upgrade to ubuntu 36
      "6")
        if [ -f upgrade ]
        then
            sudo dnf system-upgrade download --releasever=36
            rm upgrade
        else
            echo "Upgrading packages of your version of ubuntu..."
            sudo dnf --refresh upgrade -y > upgrade
            echo "Done."
            if [ $(grep -c "Nothing to do." upgrade) == 1 ];#Still to solve
            then
                echo "System updated, please reboot and run the script again to upgrade to ubuntu 36."
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
        sudo apt update
        which neofetch > /dev/null 2>&1
        if [ $? == 0 ]
        then
            echo "neofetch is already installed"
        else
            sudo apt install neofetch -y
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
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf config-manager --set-enabled google-chrome && sudo apt update -y
        #Installing packages
        #Not needed packages: blender krita shotcut kdenlive ghc-X11-xft-devel
        sudo apt install microsoft-edge-stable google-chrome-stable telegram-desktop thunderbird transmission gimp code powershell mpv remmina barrier filezilla keepassxc mumble goverlay steam bottles podman distrobox @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager vpnc cargo https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm https://download.anydesk.com/linux/anydesk-6.2.0-1.el8.x86_64.rpm https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm --skip-broken -y #&& flatpak install flathub com.visualstudio.code com.microsoft.edge org.telegram.desktop org.onlyoffice.desktopeditors
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
;;
#Quick ubuntu Server Setup
"2")
    sudo apt install https://download1.rpmfusion.org/free/ubuntu/rpmfusion-free-release-$(rpm -E %ubuntu).noarch.rpm https://download1.rpmfusion.org/nonfree/ubuntu/rpmfusion-nonfree-release-$(rpm -E %ubuntu).noarch.rpm -y
    sudo apt update -y
    #Installing essential packages
    sudo apt install wget nano curl htop neofetch NetworkManager-tui snapd curl cronie git make nodejs golang --skip-broken -y && sudo ln -s /var/lib/snapd/snap /snap && sudo snap install nextcloud
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
;;
*)
echo "Invalid option"
exit
;;
esac
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
if [[ $(hostname) == 'ubuntu' ]];
then
    echo "Please provide a hostname for the computer"
    read hostname
    sudo hostnamectl set-hostname --static $hostname
else
    echo 'hostname was not changed'
fi
#Showing system review
cowsay "The process has been completed, here is a review of your system." | lolcat && neofetch | lolcat