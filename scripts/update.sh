#!/bin/bash
# Log all output to file
LOG=carino-update$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining functions
#Defining values in variables
version=3.20220915
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#Functions
steam () {
    whereis steam
    if [ $? -eq 0 ]
    ''
}
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
# if os_id is fedora 1and os_version is greater than or equal to 35
if [ "$os_id" = "fedora" ] && [ "$os_version" -ge "35" ]; then
    # run fedora setup script
    VALID=true
    echo -e "${GREEN}This is a valid Fedora $os_id installation${ENDCOLOR}"
    sudo dnf update && bash <(curl -s https://carino.systems/scripts/protonge.sh)
# elif it's not f35 or newer
elif [ "$os_id" = "fedora" ] && [ "$os_version" -ge 35 ]; then
    # set MIGRATABLE to false
    echo -e "${RED}This script is only for Fedora 35 or newer.${ENDCOLOR}"
else
# set MIGRATABLE to false
    echo -e "${RED}OS $os_id version $os_version is not supported. Please run this script on a copy of Fedora Linux 35 or newer.${ENDCOLOR}"
    VALID=false
    exit
fi