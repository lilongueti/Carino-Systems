#!/bin/bash
###################
#Script to install AMD drivers on Workstations and Servers
###################
#Defining values in variables
version=3.20220915
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
# Log all output to file
LOG=carino-nvidia-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Printing script information
echo -e "${GREEN}Install AMD drivers${ENDCOLOR}"
#Retrieving information
# get distro data from /etc/os-release
os_id=$(grep -E '^ID=' /etc/os-release | sed -e 's/ID=//g')
# get distro version data from /etc/os-release
os_version=$(grep -E '^VERSION_ID=' /etc/os-release | sed -e 's/VERSION_ID=//g')
#Installing AMD drivers
if lspci | grep 'Radeon' > /dev/null;
then
    if nvidia-smi
    then
         echo -e "${GREEN}AMD drivers are installed already.${ENDCOLOR}"
    else
        case $os_id in
        "arch")
            echo "Arch distro"
            sudo pacman -Syu
            ;;
        "debian")
            echo "Nvidia driver for Debian"
            if [ "$os_version" -ge "10" ]; then
                sudo apt install nvidia-driver
            fi
            ;;
        "fedora")
          echo "Fedora distro"
          if [ "$os_version" -ge "35" ]; then
                    #needs depuration (too many packages?)
                    sudo dnf install kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda nvidia-driver xorg-x11-drv-nvidia-cuda-libs vdpauinfo libva-vdpau-driver libva-utils vulkan nvidia-xconfig ocl-icd-devel opencl-headers libdrm-devel systemd-devel -y && sudo nvidia-xconfig
                    if nvtop
                    then
                        echo "Nvtop already installed"
                    else
                        sudo dnf install libdrm-devel systemd-devel -y && git clone https://github.com/Syllo/nvtop.git && mkdir -p nvtop/build && cd nvtop/build && cmake .. && make && sudo make install && cd ../.. && rm -rf nvtop
                    fi
          else
              echo -e "${RED}You need Fedora 35 or greater${ENDCOLOR}, drivers won't be installed."
          fi
          ;;
        "ubuntu")
          echo "Ubuntu distro"
          sudo apt update -y && sudo apt upgrade -y
          ;;
        "slackware")
          echo "Slackware distro"
          #sudo pacman -Syu
          ;;
        "gentoo")
          echo "Gentoo distro"
          #sudo pacman -Syu
          ;;
        "rhel")
          echo "Red Hat Enterprise Linux"
          sudo dnf update -y
          ;;
        *)
          echo "Another distro"
          ;;
        esac
  fi
else
  echo -e "${RED}No AMD card detected${ENDCOLOR}, drivers won't be installed."
fi