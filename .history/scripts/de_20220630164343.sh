#!/bin/bash
if [ $XDG_CURRENT_DESKTOP == 0 ]
then
    echo "You don't have any Desktop Environment installed"
else
    echo "Your current Desktop Environment is $XDG_CURRENT_DESKTOP"
fi