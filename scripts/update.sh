#!/bin/bash
#Update script
#Defining values in variables
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
# Log all output to file
LOG=carino-update$version.log
exec > >(tee -a "$LOG") 2>&1
#Declaring Functions
steamcheck () {
    if [ $(whereis steam 2>/dev/null | wc -l) == 1 ];
    then
        bash <(curl -s https://carino.systems/scripts/protonge.sh)
    else
        echo "There is no Steam" &> /dev/null
    fi
}
nvidiacheck () {
    bash <(curl -s https://carino.systems/scripts/nvidia.sh)
}
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
case $os_id in
"arch")
  echo "Arch distro"
  sudo pacman -Syu && steamcheck
  ;;
"debian")
  echo "Debian distro"
  sudo apt update -y && sudo apt upgrade -y && steamcheck
  ;;
"fedora")
  echo "Fedora distro"
  if [ "$os_version" -ge "35" ]; then
    sudo dnf update -y && steamcheck
  else
    echo "This script is only for Fedora 35 or newer."
  fi
  ;;
"gentoo")
  echo "Gentoo distro"
  #sudo pacman -Syu && steamcheck
  ;;
"nixos")
  echo "Ubuntu distro"

  ;;
"suse")
  echo "Ubuntu distro"

  ;;
"rhel")
  echo "Red Hat Enterprise Linux"
  sudo dnf update -y && steamcheck
  ;;
"slackware")
  echo "Slackware distro"
  #sudo pacman -Syu && steamcheck
  ;;
"ubuntu")
  echo "Ubuntu distro"
  sudo apt update -y && sudo apt upgrade -y && steamcheck
  ;;
*)
  echo "Another distro"
  ;;
esac