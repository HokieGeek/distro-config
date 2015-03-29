#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "=====> Setting up locale info"
. ${mydir}/2-locale.sh || exit 22

echo "=====> Create a new initial RAM disk"
mkinitcpio -p linux

echo "=====> Set root password:"
passwd

echo "======> Configuring user"
${mydir}/4-user.sh || exit 24

[ ${bootloader} -gt 0 ] && ${mydir}/5-boot.sh || exit 25

echo "exec /distro-config/C-configure-user.sh" > /home/${myuser}/.zprofile
chown ${myuser}:users /home/${myuser}/.zprofile
