#!/bin/sh

myuser=$1

echo "=====> Set root password: "
passwd

echo "=====> Creating user '$myuser': "
pacman -S sudo bash-completion vim zsh
useradd -m -g users -G wheel,storage,power,scanner,uucp -s /bin/zsh andres
passwd andres
pacman -Ss sudo
mkdir /home/andres/.vim

echo "=====> Giving user sudo permissions"
# TODO: can this be scripted? figure out this next line
#EDITOR=vim visudo +/wheel ALL=
cp /{etc,tmp}/sudoers
sed 's/#\s*\(%wheel\)/\1/g' /tmp/sudoers > /etc/sudoers

echo "=====> Allowing user to execute pm-suspend without a password"
echo "%${myuser} ALL=(ALL) NOPASSWD: /usr/sbin/pm-suspend" >> /etc/sudoers
