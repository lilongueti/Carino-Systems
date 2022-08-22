#!/bin/bash
sudo apt update && sudo apt upgrade
sudo raspi-config
sudo apt install network-manager nginx php7.4-fpm php7.4-mbstring php7.4-mysql php7.4-curl php7.4-gd php7.4-zip php7.4-xml