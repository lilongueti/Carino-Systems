#!/bin/bash
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
#Getting User
user=$(awk -F: '{ print $1}' /etc/passwd |& tail -1)
#Workstation menu
echo -e "Fedora Setup Scripts\nVersion $version\nHello $user\nPlease select a profile:\n1. Basic profile\n2. Gaming profile\n3. Corporate profile\n4. Migrate to Ultramarine Linux\n5. Install Nvidia drivers\n6. Upgrade to Fedora 36\n7. Exit\n"
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
    DESTDIR="~/.steam/root/compatibilitytools.d"
    if [[ -d $DESTDIR ]]
    then
        echo "$DESTDIR is already on your system."
    else
        sudo mkdir ~/.steam/
        sudo mkdir ~/.steam/root/
        sudo mkdir ~/.steam/root/compatibilitytools.d
        wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-24/GE-Proton7-24.tar.gz && sudo tar -xf GE-Proton7-24.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-24.tar.gz
    fi
    ;&
  #Basic profile starts
  "1")
    echo "Basic profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour libreoffice-* -y
    #Adding repos and updating system
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf config-manager --set-enabled google-chrome && sudo dnf update -y
    #Installing essential packages
    sudo dnf install wget nano curl --skip-broken -y
    #Installing packages
    sudo dnf install telegram-desktop google-chrome-stable celluloid keepassxc thunderbird transmission gimp krita htop powertop neofetch mediainfo obs-studio wine NetworkManager-tui yt-dlp cmake lshw lm_sensors.x86_64 gnome-tweaks gnome-extensions-app git xkill tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils tigervnc-server xrdp dnf-plugins-core --skip-broken -y && flatpak install flathub org.telegram.desktop com.spotify.Client org.onlyoffice.desktopeditors -y
    support=y
    nvidia=y
    ;;
  #Corporate profile starts
  "3")
    echo "Corporate profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour libreoffice-* -y
    #Adding repos
    #Removed Microsoft repos for Edge and Code
    #sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo rpm --import https://keys.openpgp.org/vks/v1/by-fingerprint/034F7776EF5E0C613D2F7934D29FBD5F93C0CFC3 && sudo dnf config-manager --add-repo  https://rpm.librewolf.net && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    #Installing essential packages
    sudo dnf install wget nano curl --skip-broken -y
    #Installing packages
    sudo dnf install celluloid keepassxc thunderbird transmission gimp htop powertop remmina neofetch mediainfo obs-studio barrier wine NetworkManager-tui yt-dlp cmake lshw lm_sensors.x86_64 gnome-tweaks gnome-extensions-app elinks git xkill tldr qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils distrobox @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server cockpit xrdp powershell dnf-plugins-core dhcp-server --skip-broken -y && flatpak install flathub org.telegram.desktop us.zoom.Zoom com.dropbox.Client com.spotify.Client org.onlyoffice.desktopeditors com.anydesk.Anydesk com.skype.Client com.microsoft.Teams com.visualstudio.code com.microsoft.edge com.github.gi_lom.dialect com.slack.Slack com.usebottles.bottles -y
    support=y
    nvidia=y
    sharedfolder=y
    ;;
  #Ultramarine Linux migration process
  "4")
    bash <(curl -s https://ultramarine-linux.org/migrate.sh)
    ;;
  #NVIDIA driver installation
  "5")
    nvidia=y
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
    sudo dnf remove gnome-tour gnome-photos libreoffice-* -y
    #Adding repos and updating
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    #curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo &&
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    #Installing essential packages
    sudo dnf install wget nano curl --skip-broken -y
    #Installing packages
    #Not needed packages: blender microsoft-edge-stable krita shotcut kdenlive powershell
    sudo dnf install firefox keepassxc telegram-desktop code thunderbird transmission gimp htop powertop remmina neofetch mediainfo obs-studio barrier wine NetworkManager-tui yt-dlp cmake lshw lm_sensors.x86_64 gnome-tweaks gnome-extensions-app elinks git xkill mumble goverlay tldr steam qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils distrobox @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager tigervnc-server cockpit xrdp dnf-plugins-core dhcp-server https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm --skip-broken -y #&& flatpak install flathub com.visualstudio.code com.microsoft.edge org.telegram.desktop org.onlyoffice.desktopeditors 
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
        sudo -u $user ./svp4-linux-64.run && rm svp4-latest* svp4-linux-64.run  
    fi
    support=y
    mpv=y
    nvidia=y
    ;;
  *)
    echo "Invalid option"
    exit
    ;;
esac
#Installing packages according to variables
#Support
#if [ $support == y ]
#then
#    if command -v speedtest > /dev/null;
#    then
#        echo "speedtest-cli is installed"
#    else
#        curl -s https://install.speedtest.net/app/cli/install.rpm.sh | sudo bash
#        sudo dnf install speedtest
#    fi
#    if command -v rustdesk > /dev/null;
#    then
#        echo "rustdesk is already installed"
#    else
#        sudo dnf install https://github.com/rustdesk/rustdesk/releases/download/1.1.8/rustdesk-1.1.8-fedora28-centos8.rpm -y
#    fi
#fi
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
#Installing NVIDIA drivers
#echo $nvidia
if [ $nvidia == y ];
then
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
        echo "No NVIDIA card detected, driveres won't be installed."
    fi
#else
#    echo 'THE NVIDIA process has been skipped'
fi
#Setting up a hostname
if [[ $(hostname) == 'fedora' ]];
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
#Journal settings
sudo journalctl --vacuum-size=2G --vacuum-time=35d
#Showing system review
echo "The process has been completed, here is a review of your system."
neofetch | lolcat
#speedtest
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