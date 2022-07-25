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
support=n
sharedfolder=n
rdp=n
version=2.0.0.20220724
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
# if os_id is fedora and os_version is greater than or equal to 35
if [ "$os_id" = "fedora" ] && [ "$os_version" -ge "35" ]; then
    # run fedora setup script
    VALID=true
    echo "This is a valid Fedora $os_id installation"
# elif it's not f35 or newer
elif [ "$os_id" = "fedora" ] && [ "$os_version" -ge 35 ]; then
    # set MIGRATABLE to false
    echo "This script is only for Fedora 35 or newer."
else
# set MIGRATABLE to false
    echo "OS $os_id version $os_version is not supported. Please run this script on a copy of Fedora Linux 35 or newer."
    VALID=false
    exit
fi
#Getting User
user=$(awk -F: '{ print $1}' /etc/passwd |& tail -1)
if [ "$workstation" = "y" ]
then
    echo "Continuing Fedora Workstation Setup..."
    optionmenu=3
else
    echo -e "Fedora Setup Scripts\nVersion $version\nHello $user\nPlease select an option:\n1. Fedora Workstation Setup\n2. Quick Fedora Server Setup"
    read optionmenu
fi
case $optionmenu in
#
"1")
    echo "Setup Fedora Workstation"
    if [ $(cat /etc/dnf/dnf.conf | grep fastestmirror=true) ]
    then
        echo ""
    else
        sudo sh -c 'echo fastestmirror=true >> /etc/dnf/dnf.conf'
    fi
    sudo systemctl disable NetworkManager-wait-online.service
    sudo dnf update -y
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    #Asking for Desktop Environment of choice
    echo -e "What Desktop Environment you want?\n1. GNOME\n2. XFCE\n3. KDE\n4. LXQT\n5. CINNAMON\n6. MATE\n7. i3\n8. OPENBOX\n9. NONE"
    read option
    case $option in
    "1")
        sudo dnf install @workstation-product-environment -y && sudo systemctl set-default graphical.target
        echo "You have GNOME installed, moving on"
        ;;
    "2")
        sudo dnf install @xfce-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have XFCE installed, moving on"
        ;;
    "3")
        sudo dnf install @kde-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have KDE installed, moving on"
        ;;
    "4")
        sudo dnf install @lxqt-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have LXQT installed, moving on"
        ;;
    "5")
        sudo dnf install @cinnamon-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have CINNAMON installed, moving on"
        ;;
    "6")
        sudo dnf install @mate-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have MATE installed, moving on"
        ;;
    "7")
        sudo dnf install @i3-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have i3 installed, moving on"
        ;;
    "8")
        sudo dnf install @basic-desktop-environment -y && sudo systemctl set-default graphical.target
        echo "You have OPENBOX installed, moving on"
        ;;
    "9")
        echo "No Desktop Environment will be installed"
        ;;
    *)
        echo "Wrong choice"
        exit
        ;;
    esac
    #Installing NVIDIA drivers
    if lspci | grep 'NVIDIA' > /dev/null;
    then
        if [which akmod-nvidia &>/dev/null]
        then
            #needs depuration (too many packages?)
            sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers -y && sudo nvidia-xconfig && git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install && cd ../.. && rm -rf nvtop
        else
            echo "NVIDIA drivers are installed already."
        fi
    else
        echo "No NVIDIA card detected, drivers won't be installed."
    fi
    #asking for a reboot
    echo "Do you want to reboot your system?"
    read option
    if [ $option == y ]
    then
        workstation=y
        sudo reboot
    else
        echo "No reboot was requested."
    fi
;&
"3")
    #Workstation menu
    echo -e "Please select a Workstation profile:\n1. Basic profile\n2. Gaming profile\n3. Corporate profile\n4. Nakadashi profile\n5. Migrate to Nakadashi Linux\n6. Upgrade to Fedora 36\n7. Exit\n"
    read choice
    case $choice in
      #Gaming profile starts
      "2")
        echo "Gaming profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour libreoffice-* -y
        #Adding repos and updating system
        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
        #Installing essential packages
        sudo dnf install wget nano curl --skip-broken -y
        #Installing packages
        sudo dnf install steam goverlay lutris mumble --skip-broken -y && flatpak install flathub com.discordapp.Discord -y
        #Installing Proton EG
        sudo mkdir ~/.steam/
        sudo mkdir ~/.steam/root/
        sudo mkdir ~/.steam/root/compatibilitytools.d
        ;&
      #Basic profile starts
      "1")
        echo "Basic profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour libreoffice-* -y
        #Adding repos and updating system
        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm fedora-workstation-repositories -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf config-manager --set-enabled google-chrome && sudo dnf update -y
        #Installing essential packages
        sudo dnf install wget nano curl --skip-broken -y
        #Installing packages
        sudo dnf install telegram-desktop google-chrome-stable celluloid keepassxc thunderbird transmission gimp krita htop powertop neofetch mediainfo obs-studio wine NetworkManager-tui yt-dlp cmake lshw lm_sensors.x86_64 gnome-tweaks gnome-extensions-app git xkill lolcat tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils tigervnc-server xrdp dnf-plugins-core https://download.anydesk.com/linux/anydesk-6.2.0-1.el8.x86_64.rpm https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm --skip-broken -y && flatpak install flathub com.spotify.Client -y
        #Installing protondb if gaming profile was selected
        #pkgs="~/.steam/root/compatibilitytools.d"
        which steam > /dev/null 2>&1
        if [ $? == 0 ]
        then
            wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-26/GE-Proton7-26.tar.gz && sudo tar -xf GE-Proton7-26.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-26.tar.gz
            echo "ProtonEG has been installed."
        else
            echo "Gaming profile is not installed, ProtonEG will not be installed."
        fi
        ;;
      #Corporate profile starts
      "3")
        echo "Corporate profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour libreoffice-* -y
        #Adding repos
        sudo dnf install fedora-workstation-repositories && sudo dnf config-manager --set-enabled google-chrome && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo rpm --import https://keys.openpgp.org/vks/v1/by-fingerprint/034F7776EF5E0C613D2F7934D29FBD5F93C0CFC3 && sudo dnf config-manager --add-repo  https://rpm.librewolf.net && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf config-manager --set-enabled google-chrome && sudo dnf update -y
        #Installing essential packages
        sudo dnf install wget nano curl --skip-broken -y
        #Installing packages
        sudo dnf install celluloid keepassxc thunderbird transmission gimp htop telegram-desktop code microsoft-edge-stable google-chrome-stable powertop remmina neofetch mediainfo obs-studio barrier wine NetworkManager-tui yt-dlp cmake lshw lm_sensors.x86_64 gnome-tweaks gnome-extensions-app elinks git xkill lolcat tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils distrobox @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server cockpit xrdp powershell dnf-plugins-core dhcp-server https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm https://download.anydesk.com/linux/anydesk-6.2.0-1.el8.x86_64.rpm --skip-broken -y && flatpak install flathub us.zoom.Zoom com.dropbox.Client com.spotify.Client com.skype.Client com.microsoft.Teams com.slack.Slack com.usebottles.bottles -y #org.telegram.desktop org.onlyoffice.desktopeditors com.visualstudio.code com.microsoft.edge
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
            read srvuser
            sudo mkdir /home/$(whoami)/WinFiles/ && sudo mount.cifs //$server/$folder /home/$(whoami)/WinFiles/ -o user=$srvuser
            echo "Windows Shared Folder has been successfully mounted!"
        else
            echo -e "No Windows shared folders were added\n--------------------------------------"
        fi
        ;;
      #Nakadashi profile starts
      "4")
        bash <(curl -s https://ultramarine-linux.org/migrate.sh)
        ;;
      #Migration to Nakadashi Linux starts
      "5")
        bash <(curl -s https://ultramarine-linux.org/migrate.sh)
        ;;
      #Upgrade to Fedora 36
      "6")
        if [ -f upgrade ]
        then
            sudo dnf system-upgrade download --releasever=36
            rm upgrade
        else
            echo "Upgrading packages of your version of Fedora..."
            sudo dnf --refresh upgrade -y > upgrade
            echo "Done."
            if [ $(grep -c "Nothing to do." upgrade) == 1 ];#Still to solve
            then
                echo "System updated, please reboot and run the script again to upgrade to Fedora 36."
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
        echo "Testing complete, $user will now move on to the next step."
        ;;
      #Carino profile starts
      "0")
        echo "Carino profile"
        #Removing packages (reasons vary)
        sudo dnf remove gnome-tour gnome-photos libreoffice-* dnfdragora dnfdragora-updater -y
        #Adding repos and updating
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        #curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo &&
        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm fedora-workstation-repositories -y && sudo dnf config-manager --set-enabled google-chrome && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
        #Installing essential packages
        sudo dnf install wget nano curl --skip-broken -y
        #Installing packages
        #Not needed packages: blender microsoft-edge-stable krita shotcut kdenlive powershell
        sudo dnf install firefox keepassxc telegram-desktop code thunderbird transmission gimp htop powertop remmina neofetch mediainfo obs-studio barrier wine NetworkManager-tui yt-dlp cmake lshw lm_sensors.x86_64 gnome-tweaks gnome-extensions-app elinks git xkill mumble goverlay lolcat tldr steam qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils distrobox @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server cockpit xrdp dnf-plugins-core dhcp-server https://download.anydesk.com/linux/anydesk-6.2.0-1.el8.x86_64.rpm https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm --skip-broken -y #&& flatpak install flathub com.visualstudio.code com.microsoft.edge org.telegram.desktop org.onlyoffice.desktopeditors 
        #Installing packages not available in rpm or flatpak repos
        #which ipfs-desktop > /dev/null 2>&1
        #if [ $? == 0 ]
        #then
        #    echo "ipfs-desktop is already installed"
        #else
        #    sudo dnf install https://github.com/ipfs/ipfs-desktop/releases/download/v0.20.6/ipfs-desktop-0.20.6-linux-x86_64.rpm -y
        #fi
        #Compiling and installing MPV
        which mpv > /dev/null 2>&1
        if [ $? == 0 ]
        then
          echo "Mpv is already installed"
        else
          sudo dnf builddep mpv -y && sudo git clone https://github.com/mpv-player/mpv && cd mpv/ && sudo ./bootstrap.py && sudo ./waf configure --enable-vapoursynth && sudo ./waf && sudo ./waf install && cd .. && sudo rm -r mpv
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
            sudo -u $user ./svp4-linux-64.run && rm svp4-latest* svp4-linux-64.run  
        fi
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
#Quick Fedora Server Setup
"2")
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
;;
*)
echo "Invalid option"
exit
;;
esac
#Setting up a hostname
if [[ $(hostname) == 'fedora' ]];
then
    echo "Please provide a hostname for the computer"
    read hostname
    sudo hostnamectl set-hostname --static $hostname
else
    echo 'hostname was not changed'
fi
#Showing system review
echo "The process has been completed, here is a review of your system."
neofetch | lolcat