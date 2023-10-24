#!/bin/bash
installproton ()
{
  if [ $(ls ~/.steam/root/ | grep compatibilitytools.d) ]
  then
      CURRENTVERSION=$(ls ~/.steam/root/compatibilitytools.d | tail -c 3)
      for I in 31 30 29 28 27 26 25 24 23 22 21
       do
           if [[ $CURRENTVERSION -eq $I ]]
           then
               echo -e "${GREEN}You already have the latest ProtonGE $I version.${ENDCOLOR}"
           else
               PROTONVERSION=$I
               wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton8-$PROTONVERSION/GE-Proton8-$PROTONVERSION.tar.gz &> /dev/null
               if [ $? -eq 0 ]
               then
                   echo -e "Installing version $PROTONVERSION..."
                   sudo tar -xf GE-Proton8-$PROTONVERSION.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton8-$PROTONVERSION.tar.gz
                   echo -e "${GREEN}ProtonGE $PROTONVERSION has been installed.${ENDCOLOR}"
                   break
               else
                   echo -e "${RED}Version $PROTONVERSION not found (yet).${ENDCOLOR}" &> /dev/null
               fi
           fi
       done
  else
      sudo mkdir -p ~/.steam/root/compatibilitytools.d
      installproton
  fi
}

installproton