#!/bin/bash
#Installing Proton GE Script
#Defining values in variables
version=3.20220915
RED="\e[31m"
BLUE="\e[94m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
# Log all output to file
LOG=carino-protonge-setup$version.log
exec > >(tee -a "$LOG") 2>&1
#Installing Proton GE
installproton () {
CURRENTVERSION=$(ls ~/.steam/root/compatibilitytools.d | tail -c 3)
   for I in 40 39 38 37 36 35 34 33
    do
        if [[ $CURRENTVERSION -eq $I ]]
        then
            echo -e "${GREEN}You already have the latest ProtonGE $I version.${ENDCOLOR}"
        else
            PROTONVERSION=$I
            wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-$PROTONVERSION/GE-Proton7-$PROTONVERSION.tar.gz &> /dev/null
            if [ $? -eq 0 ]
            then
                echo -e "Installing version $PROTONVERSION..."
                sudo tar -xf GE-Proton7-$PROTONVERSION.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton7-$PROTONVERSION.tar.gz
                echo -e "${GREEN}ProtonGE $PROTONVERSION has been installed.${ENDCOLOR}"
                break
            else
                echo -e "${RED}Version $PROTONVERSION not found (yet).${ENDCOLOR}" &> /dev/null
            fi
        fi
    done
}
#Script starts
if [ $(ls ~/.steam/root/ | grep compatibilitytools.d) ]
then
    installproton
else
    sudo mkdir ~/.steam/ &> /dev/null
    sudo mkdir ~/.steam/root/ &> /dev/null
    sudo mkdir ~/.steam/root/compatibilitytools.d
    installproton
fi