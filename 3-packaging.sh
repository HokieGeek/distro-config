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
