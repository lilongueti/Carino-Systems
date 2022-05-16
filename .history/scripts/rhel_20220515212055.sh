#!/bin/bash
#Setup script for Red Hat Workstations
# Log all output to file
LOG=carino-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining functions
#Defining values in variables
nvidia=n
support=n
mpv=n
sharedfolder=n
version=2.0.0.20220515
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
# if os_id is rhel and os_version is greater than or equal to 35
if [ "$os_id" = "rhel" ] && [ "$os_version" -ge 9.0 ]; then
    # run rhel setup script
    VALID=true
# elif it's not f35 or newer
elif [ "$os_id" = "fedora" ] || [ "$os_version" -lt 35 ]; then
    # set MIGRATABLE to false
    echo "This script is only for RHEL 9 or newer."
else
# set MIGRATABLE to false
    echo "OS $os_id version $os_version is not supported. Please run this script on a copy of RHEL 9 or newer."
    VALID=false
fi
#Getting User
user=$(awk -F: '{ print $1}' /etc/passwd |& tail -1)
#Main Menu
echo -e "RHEL Setup Scripts\nVersion $version\nHello $user\nPlease select a profile:\n1. Basic profile\n2. Gaming profile\n3. Corporate profile\n4. Migrate to Alma Linux\n5. Install Nvidia drivers (NA)\n6. Upgrade to RHEL 9\n7. Exit\n"
read choice
case $choice in
  #Gaming profile starts
  "2")
    echo "Gaming profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour libreoffice-* -y
    #Adding repos and updating system
    sudo subscription-manager repos --enable codeready-builder-beta-for-rhel-9-$(arch)-rpms && sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    sudo dnf install steam goverlay lutris mumble -y && flatpak install flathub com.discordapp.Discord -y
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
    sudo dnf remove gnome-tour libreoffice-* -y
    #Adding repos and updating system
    sudo subscription-manager repos --enable codeready-builder-beta-for-rhel-9-$(arch)-rpms && sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    #Installing packages
    #Not available in the repo | celluloid keepassxc thunderbird transmission krita obs-studio wine yt-dlp tldr
    sudo dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm ntfs-3g gimp htop powertop neofetch mediainfo NetworkManager-tui cmake lshw gnome-tweaks gnome-extensions-app git xkill qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils tigervnc-server xrdp dnf-plugins-core -y && flatpak install flathub io.mpv.Mpv org.telegram.desktop com.spotify.Client org.onlyoffice.desktopeditors -y
    support=y
    nvidia=y
    ;;
  #Corporate profile starts
  "3")
    echo "Corporate profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour libreoffice-* -y
    #Adding repos
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo subscription-manager repos --enable codeready-builder-beta-for-rhel-9-$(arch)-rpms && sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    #Installing packages
    #Not available in the repo | elinks
    sudo dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm ntfs-3g gimp htop powertop neofetch mediainfo NetworkManager-tui cmake lshw gnome-tweaks gnome-extensions-app git xkill qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils @"Virtualization Client" tigervnc-server xrdp powershell dnf-plugins-core -y && flatpak install flathub io.mpv.Mpv com.microsoft.code com.microsoft.edge org.telegram.desktop us.zoom.Zoom com.dropbox.Client com.spotify.Client org.onlyoffice.desktopeditors com.anydesk.Anydesk com.skype.Client com.microsoft.Teams com.github.gi_lom.dialect com.slack.Slack com.usebottles.bottles org.remmina.Remmina -y
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
  #Exit program
  "6")
    echo "Exit"
    exit
    ;;
  #Carino profile starts
  "0")
    echo "Carino profile"
    #Removing packages (reasons vary)
    sudo dnf remove gnome-tour firefox libreoffice-* -y
    #Adding repos and updating
    #Adding repos
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo subscription-manager repos --enable codeready-builder-beta-for-rhel-9-$(arch)-rpms && sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo dnf update -y
    #Installing packages
    sudo dnf install ntfs-3g gimp kdenlive shotcut blender htop powertop neofetch mediainfo NetworkManager-tui cmake lshw gnome-tweaks gnome-extensions-app git xkill qt5-qtbase-devel python3-vapoursynth bridge-utils cifs-utils @"Virtualization Client" tigervnc-server xrdp powershell dnf-plugins-core -y && flatpak install flathub com.microsoft.code com.microsoft.edge org.telegram.desktop com.spotify.Client org.onlyoffice.desktopeditors com.anydesk.Anydesk com.skype.Client com.github.gi_lom.dialect com.usebottles.bottles org.remmina.Remmina -y

    #Installing packages not available in rpm or flatpak repos
    which distrobox > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "distrobox is already installed"
    else
        curl https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
    fi
    which ipfs-desktop > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "ipfs-desktop is already installed"
    else
        sudo dnf install https://github.com/ipfs/ipfs-desktop/releases/download/v0.18.1/ipfs-desktop-0.18.1-linux-x86_64.rpm -y
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
    nvidia=y
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
    if command -v curl > /dev/null;
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
#Installing NVIDIA drivers
#echo $nvidia
#if [ $nvidia == y ];
#then
#    if lspci | grep 'NVIDIA' > /dev/null;
#    then
#        if [which akmod-nvidia &>/dev/null]
#        then
#            #needs depuration (too many packages?)
#            sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers -y && sudo nvidia-xconfig && git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install && cd ../.. && rm -rf nvtop
#        else
#            echo "NVIDIA drivers are installed already."
#        fi
#    else
#        echo "NVIDIA drivers were not installed."
#    fi
#else
#    echo 'THE NVIDIA process has been skipped'
#fi
#Setting up a hostname
if [[ $(hostname) == 'localhost' ]];
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