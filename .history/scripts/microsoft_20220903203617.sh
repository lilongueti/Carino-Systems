#!/bin/bash
###################
#Microsoft script for Workstations
#------------------------------------------------
#May Update system and kernel
#Adds specific repositories and make specific configurations
#Installs specific packages
###################
# Log all output to file
LOG=carino-ms-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining functions
#Defining values in variables
version=1.20220903
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
# if os_id is fedora 1and os_version is greater than or equal to 35
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
echo -e "${BLUE}Microsoft setup for Fedora systems${ENDCOLOR}\n${RED}Pending:\n-Immediate OneDrive setup with rclone\-Windows Themes\n-RHEL dynamic wallpaper config\n-Specific packages for SQL${ENDCOLOR}\nPlease choice an option\n1.Microsoft Essentials - Simply installs Edge, Skype and Teams. With Office alternatives (OnlyOffice and Thunderbird)\n2.Microsoft IT & Development - Essential packages plus VSCode, .NET, Powershell, Azure Data Studio, SQL, GitDesktop. With RDP/Hyper-V alternatives (Remmina/KVM)"
read choice
case $choice in
    "1")
        #Repositories
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && sudo dnf update -y
        #Installs Microsoft packages
        sudo dnf install microsoft-edge-stable https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm https://repo.skype.com/latest/skypeforlinux-64.rpm -y --skip-broken
        #Installs Alternative packages
        sudo dnf install celluloid thunderbird https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm
        ;;
    "2")
        #Repositories
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf update -y
        #Installs Microsoft packages
        sudo dnf install microsoft-edge-stable code powershell dotnet https://sqlopsbuilds.azureedge.net/stable/7553f799e175f471b7590302dd65c997b838b29b/azuredatastudio-linux-1.39.1.rpm https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm https://repo.skype.com/latest/skypeforlinux-64.rpm https://github.com/shiftkey/desktop/releases/download/release-3.0.5-linux1/GitHubDesktop-linux-3.0.5-linux1.rpm -y --skip-broken
        #Installs Alternative packages
        sudo dnf install celluloid thunderbird https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors.x86_64.rpm remmina @virtualization libvirt libvirt-devel virt-install qemu-kvm qemu qemu-img python3 python3-pip virt-manager
        ;;
    *)
      echo "${RED}Nothing was selected. Exiting the script.${ENDCOLOR}"
      exit
      ;;
esac
