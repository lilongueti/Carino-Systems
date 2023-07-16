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
hardwareAcceleration=$(glxinfo | grep "direct rendering")
hardwareRenderer=$(glxinfo | grep "direct rendering" | awk '{print $3}')
archType=$(lscpu | grep -e "^Architecture:" | awk '{print $NF}')
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
identifyDistro ()
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
}
displayMenu ()
{
  clear
  success "-------------------------------------"
  success " $NAME $VERSION_ID Setup Script"
  success "-------------------------------------"
  echo "Version: 1.1"
  info "Detected Distribution: $DISTRIBUTION $VERSION_ID"
  info "Latest GitHub Commit: $latest_commit"
  info "Latest Linux Kernel Version: $latest_kernel"
  info "Your Kernel Version: $(uname -r)"
  info "CPU Architecture: $archType"
  if [[ $hardwareAcceleration == "No" ]]; then
    error "Hardware acceleration enabled: $hardwareAcceleration"
    error "Hardware renderer: $hardwareRenderer"
    else
    info "Hardware acceleration enabled: $hardwareAcceleration"
    info "Hardware renderer: $hardwareRenderer"
  fi
  info "-------------------------------------"
  echo "Please select an option:"
  echo "1. Technical Setup"
  echo "2. Purpose Setup"
  echo "3. Server Setup"
  echo "4. Exit"
  read optionmenu
  case $optionmenu in
    1)
        caution "Tech Setup Runs"
        ;;
    2)
        caution "Purpose Setup Runs"
        purposeMenu
        ;;
    3)
        caution "Server Setup Runs"
        ;;
    4)
        caution "Exit"
        ;;
    *)
        error "Bad input"
        ;;
    esac

}
purposeMenu ()
{
  clear
  success "-------------------------------------"
  success " $NAME $VERSION_ID Setup Script"
  success "-------------------------------------"
  info "Please select a purpose for your distro"
  info "-------------------------------------"
  echo " 1. Basic"
  echo " 2. Gaming"
  echo " 3. Corporate"
  echo " 4. Development"
  echo " 5. Astronomy"
  echo " 6. Comp-Neuro"
  echo " 7. Desing"
  echo " 8. Jam"
  echo " 9. Security Lab"
  echo "10. Robotics"
  echo "11. Scientific"
  echo "12. Offline"

  read optionmenu
  case $optionmenu in
    1)
        caution $1
        ;;
    2)
        caution $1
        ;;
    3)
        caution $1
        ;;
    4)
        caution $1
        ;;
    5)
        caution $1
        ;;
    6)
        caution $1
        ;;
    7)
        caution $1
        ;;
    8)
        caution $1
        ;;
    9)
        caution $1
        ;;
    10)
        caution $1
        ;;
    11)
        caution $1
        ;;
    0)
        caution $1
        ;;
    *)
        # Code to execute when $variable doesn't match any of the specified values
        ;;
    esac
}
identifyDistro
displayMenu
