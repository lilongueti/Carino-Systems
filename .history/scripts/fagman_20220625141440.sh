#!/bin/bash
#Script to install applications related to Facebook, Apple, Google, Microsoft, Amazon and Netflix
#For Fedora only, but it is planned to work on Debian, Arch and Fedora this year
#This very first version just installs Microsoft ecosystem
echo "FAGMAN script version 0.1 - It just installs Microsoft repo with Edge and Visual Studio Code"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge && sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/vscode
sudo dnf install microsoft-edge-stable code -y --skip-broken #powershell
echo "\n Done."