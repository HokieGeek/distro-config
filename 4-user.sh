#!/bin/sh

myuser=$1

pacman -S sudo bash-completion vim zsh
echo "Set root password: "
passwd
useradd -m -g users -G wheel,storage,power -s /bin/zsh andres
echo "Set password for '$myuser': "
passwd andres
pacman -Ss sudo

echo "Uncomment this line: '%wheel ALL=(ALL) ALL'"
EDITOR=vim visudo
