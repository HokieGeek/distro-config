#!/bin/sh

[ $# -gt 0 ] && myuser=$1 || myuser=`whoami`
# bootloader=0

. ${mydir}/2-locale.sh
${mydir}/3-packaging.sh
${mydir}/4-user.sh ${myuser}
## This box already has a bootloader in /boot (/dev/sda2)
# [ ${bootloader} -gt 0 ] && ${mydir}/5-boot.sh --efi /dev/sda2

echo "exec ${mydir}/C-configure-user.sh ${myuser}" > /home/${myuser}/.zprofile

