#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Install networking tools"
${mydir}/0-network.sh || exit 1

. ${mydir}/2-locale.sh || exit 2
${mydir}/3-packaging.sh || exit 3
${mydir}/4-user.sh ${myuser} ${myhostname} || exit 4
[ ${bootloader} -gt 0 ] && ${mydir}/5-boot.sh || exit 5
${mydir}/6-startup.sh || exit 6

echo "exec ${mydir}/C-configure-user.sh" > /home/${myuser}/.zprofile
chown ${myuser}:users /home/${myuser}/.zprofile
