#!/bin/bash
echo "DESKTOP ENVIRONMENT"
if [ $XDG_CURRENT_DESKTOP ]
then
    echo "Your current Desktop Environment is $XDG_CURRENT_DESKTOP"
else
    echo "You don't have any Desktop Environment installed"
fi