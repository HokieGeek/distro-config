#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "=====> Setting up locale info"
. ${mydir}/locale.sh || exit 22

echo "=====> System configurations"
${mydir}/sys-config.sh || exit 23

echo "=====> Installing bootloader"
[ ${bootloader} -gt 0 ] && ${mydir}/boot.sh || exit 24

echo "======> Configuring user"
${mydir}/user.sh || exit 25

echo "exec /distro-config/C-configure-user.sh" > /home/${myuser}/.zprofile
chown ${myuser}:users /home/${myuser}/.zprofile
