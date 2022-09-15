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
    for I in 33 34 35 36 37 38 39 40
    do
        PROTONVERSION=$I
        wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-$PROTONVERSION/GE-Proton7-$PROTONVERSION.tar.gz
        if [ $? -eq 0 ]
        then
            echo -e "Installing version $PROTONVERSION..."
            sudo tar -xf GE-Proton7-$PROTONVERSION.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-$PROTONVERSION.tar.gz
            echo -e "Done!"
            break
        else
            echo -e "${RED}Version $PROTONVERSION not founded (yet).${ENDCOLOR}"
        fi
    done
    echo -e "${GREEN}ProtonEG $PROTONVERSION has been updated.${ENDCOLOR}"
else
    sudo mkdir ~/.steam/
    sudo mkdir ~/.steam/root/
    sudo mkdir ~/.steam/root/compatibilitytools.d
    for I in 40 39 38 37 36 35 34 33
    do
        PROTONVERSION=$I
        wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-$PROTONVERSION/GE-Proton7-$PROTONVERSION.tar.gz
        if [ $? -eq 0 ]
        then
            echo -e "Installing version $PROTONVERSION..."
            sudo tar -xf GE-Proton7-$PROTONVERSION.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-$PROTONVERSION.tar.gz
            echo -e "Done!"
            break
        else
            echo -e "${RED}Version $PROTONVERSION not founded (yet).${ENDCOLOR}"
        fi
    done
    echo -e "${GREEN}ProtonEG $PROTONVERSION has been installed by creating folders.${ENDCOLOR}"
fi