#!/bin/bash
installproton ()
{
  if [ $(ls ~/.steam/root/ | grep compatibilitytools.d) ]
  then
      CURRENTVERSION=$(ls ~/.steam/root/compatibilitytools.d | tail -c 3)
      for I in 15 14 13 12 11 10 9 8 7 6 5 4
       do
           if [[ $CURRENTVERSION -eq $I ]]
           then
               echo -e "${GREEN}You already have the latest ProtonGE $I version.${ENDCOLOR}"
           else
               PROTONVERSION=$I
               wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton9-$PROTONVERSION/GE-Proton9-$PROTONVERSION.tar.gz &> /dev/null
               if [ $? -eq 0 ]
               then
                   echo -e "Installing version $PROTONVERSION..."
                   sudo tar -xf GE-Proton9-$PROTONVERSION.tar.gz -C ~/.steam/root/compatibilitytools.d && rm GE-Proton9-$PROTONVERSION.tar.gz
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