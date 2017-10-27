#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

# . ${mydir}/config.prop
myuser=andres
#userDir=/home/andres

echo "=====> Creating user '$myuser'"
# useradd -m -g users -G wheel,storage,power,scanner,uucp -s /usr/bin/zsh ${myuser}
useradd -m -G wheel,storage,power,scanner,uucp,lock,lp -s /usr/bin/zsh ${myuser}
# wheel audio docker andres kvm
# useradd -m -G wheel,storage,power,scanner,uucp,lock,docker,lp,printadmin -s /usr/bin/zsh ${myuser}
passwd ${myuser}
# mkdir ${userDir}/.vim
# chown ${myuser}:users ${userDir}/.vim

#echo "=====> Setting home directory encryption"
#pacman -S --needed encfs pam_encfs
#encryptedHome=${userDir}/.Encrypted
#mkdir ${encryptedHome}
#encfs ${userDir} ${encryptedHome}

## Configure for single password sign-on
#/etc/security/pam_encfs.conf
#encfs_default --idle=1

echo "=====> Giving user sudo permissions"
sed -i 's/#\s*\(%wheel\)/\1/g' /etc/sudoers

echo "=====> Allowing user to execute pm-suspend without a password"
echo "%${myuser} ALL=(ALL) NOPASSWD: /usr/sbin/pm-suspend" >> /etc/sudoers
