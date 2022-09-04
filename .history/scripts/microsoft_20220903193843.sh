#!/bin/bash
###################
#Fedora Setup Script for Workstations and Servers
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
version=3.20220903
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
echo "Microsoft setup for Fedora systems\nPending:\n-Immediate OneDrive setup with rclone\-Windows Themes\n-RHEL dynamic wallpaper config\n-Specific packages for SQL"
read choice
case $choice in
    "Microsoft essentials")
        sudo rpm --import di/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && sudo dnf update -y
        sudo dnf install microsoft-edge-stable code powershell https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm https://repo.skype.com/latest/skypeforlinux-64.rpm -y --skip-broken
        ;;
    "Microsoft Developer")
        sudo rpm --import di/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf update -y
        sudo dnf install microsoft-edge-stable code powershell dotnet mdatp https://sqlopsbuilds.azureedge.net/stable/7553f799e175f471b7590302dd65c997b838b29b/azuredatastudio-linux-1.39.1.rpm https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm https://repo.skype.com/latest/skypeforlinux-64.rpm https://github.com/shiftkey/desktop/releases/download/release-3.0.5-linux1/GitHubDesktop-linux-3.0.5-linux1.rpm -y --skip-broken
        ;;
    "Microsoft IT")
        sudo rpm --import di/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf update -y
        sudo dnf install microsoft-edge-stable code powershell dotnet mdatp https://sqlopsbuilds.azureedge.net/stable/7553f799e175f471b7590302dd65c997b838b29b/azuredatastudio-linux-1.39.1.rpm https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm https://repo.skype.com/latest/skypeforlinux-64.rpm https://github.com/shiftkey/desktop/releases/download/release-3.0.5-linux1/GitHubDesktop-linux-3.0.5-linux1.rpm -y --skip-broken
    "Microsoft Bloat")
        sudo rpm --import di/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-beta.repo && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode && curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && sudo dnf update -y
        sudo dnf install microsoft-edge-stable code powershell dotnet dotnet-sdk-3.1 mdatp https://sqlopsbuilds.azureedge.net/stable/7553f799e175f471b7590302dd65c997b838b29b/azuredatastudio-linux-1.39.1.rpm https://packages.microsoft.com/yumrepos/ms-teams/teams-1.5.00.10453-1.x86_64.rpm https://repo.skype.com/latest/skypeforlinux-64.rpm https://github.com/shiftkey/desktop/releases/download/release-3.0.5-linux1/GitHubDesktop-linux-3.0.5-linux1.rpm -y --skip-broken
        ;;
        *)
        echo "${RED}Nothing was selected. Exiting the script.${ENDCOLOR}"
        ;;
echo "\n Done."
        ;;
esac
