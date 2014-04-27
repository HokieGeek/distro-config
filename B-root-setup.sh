#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Install networking tools"
${mydir}/0-network.sh "--${network}" --install

. ${mydir}/2-locale.sh
${mydir}/3-packaging.sh
${mydir}/4-user.sh ${myuser} ${myhostname}
[ ${bootloader} -gt 0 ] && ${mydir}/5-boot.sh
${mydir}/6-startup.sh

echo "exec ${mydir}/C-configure-user.sh" > /home/${myuser}/.zprofile
chown ${myuser}:users /home/${myuser}/.zprofile
