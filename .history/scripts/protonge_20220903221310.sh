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
    PROTONVERSION=$(ls ~/.steam/root/compatibilitytools.d | tail -c 3) && PROTONVERSION=$(($PROTONVERSION+1))
    wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-$PROTONVERSION/GE-Proton7-$PROTONVERSION.tar.gz && sudo tar -xf GE-Proton7-$PROTONVERSION.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-$PROTONVERSION.tar.gz
    echo "${GREEN}ProtonEG has been installed.${ENDCOLOR}"
else
    sudo mkdir ~/.steam/
    sudo mkdir ~/.steam/root/
    sudo mkdir ~/.steam/root/compatibilitytools.d
    for I in 35 34 33 32 31
    do
        PROTONVERSION=$I
        if [ $(wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-$PROTONVERSION/GE-Proton7-$PROTONVERSION.sha512sum) ]
        then
            wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-$PROTONVERSION/GE-Proton7-$PROTONVERSION.tar.gz && sudo tar -xf GE-Proton7-$PROTONVERSION.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-$PROTONVERSION.tar.gz
            break
        fi
    done


    wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-31/GE-Proton7-31.tar.gz && sudo tar -xf GE-Proton7-31.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-31.tar.gz
    echo "${GREEN}ProtonEG has been installed by creating folders.${ENDCOLOR}"
fi