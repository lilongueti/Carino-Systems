#!/bin/bash
echo "DESKTOP ENVIRONMENT"
if [[ -d $XDG_CURRENT_DESKTOP ]]
then
    echo "You don't have any Desktop Environment installed"
else
    echo "Your current Desktop Environment is $XDG_CURRENT_DESKTOP"
fi