#!/bin/bash
# Log all output to file
LOG=carino-protonge-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Installing Proton EG
#Defining values in variables
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#Script starts
if [ $(ls ~/.steam/root/ | grep compatibilitytools.d) ]
then
    wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-31/GE-Proton7-31.tar.gz && sudo tar -xf GE-Proton7-31.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-31.tar.gz
    echo "${GREEN}ProtonEG has been installed.${ENDCOLOR}"
else
    sudo mkdir ~/.steam/
    sudo mkdir ~/.steam/root/
    sudo mkdir ~/.steam/root/compatibilitytools.d
    wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-31/GE-Proton7-31.tar.gz && sudo tar -xf GE-Proton7-31.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-31.tar.gz
    echo "${GREEN}ProtonEG has been installed by creating folders.${ENDCOLOR}"
fi