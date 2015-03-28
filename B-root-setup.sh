#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Install networking tools"
#${mydir}/0-network.sh
#|| exit 21

echo "=====> Setting hostname '$myhostname'"
echo ${myhostname} > /etc/hostname

. ${mydir}/2-locale.sh || exit 22

echo "=====> Create a new initial RAM disk with"
mkinitcpio -p linux

echo "=====> Set root password:"
passwd

[ ${bootloader} -gt 0 ] && ${mydir}/5-boot.sh || exit 25

#${mydir}/3-packaging.sh || exit 23
#${mydir}/4-user.sh ${myuser} ${myhostname} || exit 24
#${mydir}/6-startup.sh || exit 26

# echo "exec ${mydir}/C-configure-user.sh" > /home/${myuser}/.zprofile
# chown ${myuser}:users /home/${myuser}/.zprofile
