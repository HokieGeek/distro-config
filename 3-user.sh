#!/bin/sh
echo "Uncomment multilib"
vi /etc/pacman.conf
pacman -Sy

passwd
useradd -m -g users -G wheel,storage,power -s /bin/bash andres
passwd andres
pacman -S sudo bash-completion vim
pacman -Ss sudo

echo "Uncomment this line: '%wheel ALL=(ALL) ALL'"
EDITOR=vim visudo
