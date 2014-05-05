#!/bin/sh

# here=$(cd `dirname $0`; pwd)

# . ${mydir}/config.prop

myuser=$1
myhostname=$2

echo "=====> Set root password: "
passwd

echo "=====> Setting hostname '$myhostname'"
echo $myhostname > /etc/hostname

echo "=====> Creating user '$myuser'"
pacman -S --needed sudo bash-completion gvim zsh
useradd -m -g users -G wheel,storage,power,scanner,uucp -s /bin/zsh andres
passwd ${myuser}
mkdir ${userDir}/.vim
chown ${myuser}:users ${userDir}/.vim

#echo "=====> Setting home directory encryption"
#pacman -S --needed encfs pam_encfs
#encryptedHome=${userDir}/.Encrypted
#mkdir ${encryptedHome}
#encfs ${userDir} ${encryptedHome}

## Configure for single password sign-on
#/etc/security/pam_encfs.conf
#encfs_default --idle=1

echo "=====> Giving user sudo permissions"
# TODO: can this be scripted? figure out this next line
#EDITOR=vim visudo +/wheel ALL=
cp /{etc,tmp}/sudoers
sed 's/#\s*\(%wheel\)/\1/g' /tmp/sudoers > /etc/sudoers

echo "=====> Allowing user to execute pm-suspend without a password"
echo "%${myuser} ALL=(ALL) NOPASSWD: /usr/sbin/pm-suspend" >> /etc/sudoers
