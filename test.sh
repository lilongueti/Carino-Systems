#!/bin/bash
#Setup script
# Log all output to file
currentDate=$(date +%Y%M%D)
LOG=carino-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Defining Agnostic Variables
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#Declaring Specific Variables
USERNAME="MiguelCarino"
REPO="Carino-Systems"
latest_commit=$(curl -s "https://api.github.com/repos/$USERNAME/$REPO/commits?per_page=1" | jq -r '.[0].commit.message')
latest_commit_time=$(curl -s "https://api.github.com/repos/$USERNAME/$REPO/commits?per_page=1" | grep -m 1 '"date":' | awk -F'"' '{print $4}')
latest_kernel=$(curl -s https://www.kernel.org/releases.json | jq -r '.releases[1].version')
#Declaring Agnostic Functions
info ()
{
  echo -e "${BLUE}$1${ENDCOLOR}"
}
error ()
{
  echo -e "${RED}$1${ENDCOLOR}"
}
caution ()
{
  echo -e "${YELLOW}$1${ENDCOLOR}"
}
success ()
{
  echo -e "${GREEN}$1${ENDCOLOR}"
}
#Declaring Specific Functions
# Fetching the latest commit

display_menu ()
{
if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ -n "$NAME" ]]; then
            DISTRIBUTION=$NAME
            VERSION=$VERSION_ID
        fi
    elif [[ -f /etc/lsb-release ]]; then
        source /etc/lsb-release
        if [[ -n "$DISTRIB_ID" ]]; then
            DISTRIBUTION=$DISTRIB_ID
            VERSION=$DISTRIB_RELEASE
        fi
    elif [[ -f /etc/debian_version ]]; then
        DISTRIBUTION="Debian"
        VERSION=$(cat /etc/debian_version)
    elif [[ -f /etc/centos-release ]]; then
        DISTRIBUTION=$(cat /etc/centos-release | awk '{print $1}')
        VERSION=$(cat /etc/centos-release | awk '{print $4}' | cut -d'.' -f1)
    else
        DISTRIBUTION="Unknown"
        VERSION="Unknown"
    fi
    arch_type=$(lscpu | grep -e "^Architecture:" | awk '{print $NF}')
}
checksetup ()
{
#Check if script has been run before
if [[ -f ~/.linux_setup_completed ]]; then
    display_menu
else
    detect_distribution
    touch ~/.linux_setup_completed
fi
}

firstMenu ()
{
  clear
  echo "-------------------------------------"
  echo "  $NAME $VERSION_ID Setup Script"
  echo "-------------------------------------"
  echo "Version: 1.1"
  echo "Detected Distribution: $distribution"
  echo "Latest GitHub Commit: latest_commit"
  echo "Latest Linux Kernel Version: $latest_kernel"
  echo "Your Kernel Version: $(uname -r)"
  echo "-------------------------------------"
  echo "Please select an option:"
  echo "1. Install Packages"
  echo "2. Run Custom Scripts"
  echo "3. Configure Purpose-Driven Settings"
  echo "4. Exit"
  read optionmenu
}
firstMenu