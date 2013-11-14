#!/bin/sh

myuser=$1

pacman -S sudo bash-completion vim zsh
echo "=====> Set root password: "
passwd
useradd -m -g users -G wheel,storage,power,scanner,uucp -s /bin/zsh andres
echo "=====> Set password for '$myuser': "
passwd andres
pacman -Ss sudo

echo "=====> Giving user sudo permissions"
# TODO: can this be scripted? figure out this next line
#EDITOR=vim visudo +/wheel ALL=
cp /{etc,tmp}/sudoers
sed 's/#\s*\(%wheel\)/\1/g' /tmp/sudoers > /etc/sudoers

echo "=====> Allowing user to execute pm-suspend without a password"
echo "%${myuser} ALL=(ALL) NOPASSWD: /usr/sbin/pm-suspend" >> /etc/sudoers
