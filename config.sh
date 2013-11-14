#!/bin/sh

mydir=(cd `dirname $0`; pwd)

myuser=andres

${mydir}/1-fs.sh sda sda1 sda2 sda3

arch-chroot /mnt \
(. ${mydir}/2-locale.sh &&
${mydir}/3-packaging.sh &&
${mydir}/4-user.sh $myuser &&
${mydir}/5-boot.sh --efi && exit)

umount /mnt/home
umount /mnt

echo "Ok. Reboot and log in as '$myuser'"
reboot

${mydir}/6-network.sh --wifi &&
${mydir}/7-xtools.sh &&
${mydir}/8-environment.sh &&
${mydir}/9-apps.sh

echo "Done!"
