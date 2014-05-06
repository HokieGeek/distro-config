#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Install networking tools"
${mydir}/0-network.sh
#|| exit 21

. ${mydir}/2-locale.sh || exit 22
${mydir}/3-packaging.sh || exit 23
${mydir}/4-user.sh ${myuser} ${myhostname} || exit 24
[ ${bootloader} -gt 0 ] && ${mydir}/5-boot.sh || exit 25
${mydir}/6-startup.sh || exit 26

echo "exec ${mydir}/C-configure-user.sh" > /home/${myuser}/.zprofile
chown ${myuser}:users /home/${myuser}/.zprofile
