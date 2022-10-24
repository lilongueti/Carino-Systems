#!/bin/bash
#Setup script
#Defining values in variables
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#Declaring Functions

#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
case $os_id in
"arch")
  echo "Arch distro"
  bash<(curl -s https://carino.systems/scripts/arch.sh)
  ;;
"debian")
  echo "Debian distro"

  ;;
"fedora")
  echo "Fedora distro"
  if [ "$os_version" -ge "35" ]; then
    bash<(curl -s https://carino.systems/scripts/fedora.sh)
  else
    echo "This script is only for Fedora 35 or newer."
  fi
  ;;
"gentoo")
  echo "Gentoo distro"

  ;;
"nixos")
  echo "Ubuntu distro"

  ;;
"suse")
  echo "Ubuntu distro"

  ;;
"rhel")
  echo "Red Hat Enterprise Linux"

  ;;
"slackware")
  echo "Slackware distro"

  ;;
"ubuntu")
  echo "Ubuntu distro"
  bash<(curl -s https://carino.systems/scripts/ubuntu.sh)
  ;;
*)
  echo "Another distro"
  ;;
esac