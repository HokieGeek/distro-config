#!/bin/sh

echo "=====> Updating pacman packages"
cp /{etc,tmp}/pacman.conf
sed '/#\(\[multilib\]\)/{
s/#\(.*\)/\1/;
N
s/#\(.*\)/\1/;
}' /tmp/pacman.conf > /etc/pacman.conf
#sed 's/#\(\[multilib\]\)/\1/g' /tmp/pacman.conf > /etc/pacman.conf
#vi /etc/pacman.conf
pacman -Sy
