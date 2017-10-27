#!/bin/sh

#echo "=====> Updating mirrors list"
# TODO: by speed and status

echo "=====> Updating pacman packages"
sudo sed -i '/#\(\[multilib\]\)/{
s/#\(.*\)/\1/;
N
s/#\(.*\)/\1/;
}' /etc/pacman.conf
sudo pacman -Sy

echo "======> Installing packages"
# Because: shiiiit!
sudo mount -o remount,size=10G,noatime /tmp

# ${here}/packageInstaller.sh ${here}/configuration/packages
# TODO
