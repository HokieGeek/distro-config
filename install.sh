#!/bin/bash

#exec 2>&1 >/tmp

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Setting up networking"
${mydir}/0-network.sh
# || exit 11

echo "======> Configuring filesystem"
${mydir}/1-fs.sh || exit 12

echo "======> Installing base system"
pacman -S --needed sudo dosfstools gummiboot efibootmgr iw netctl wpa_supplicant wpa_actiond dialog ifplugd -r ${rootDir}
arch-chroot ${rootDir} /distro-config/B-root-setup.sh

echo "======> Leaving installation environment"
echo "Rebooting in 5 seconds"
echo "Remove install media and remember log in as '${myuser}'"
sleep 5s
umount ${rootDir}/${bootDir}
umount ${rootDir}/${homeDir}
umount ${rootDir}
[ -d /media ] && {
    cd ~
    umount /media
}
echo "I've always been in love with you"
sleep 0.5s
reboot
