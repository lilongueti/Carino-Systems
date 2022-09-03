#!/bin/bash
#Installing Proton EG
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