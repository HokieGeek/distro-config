#!/bin/bash

#exec 2>&1 >/tmp/build.log

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/configuration/config.prop

echo "======> Setting up networking"
${mydir}/network.sh
# || exit 11

echo "======> Configuring filesystem"
${mydir}/fs.sh || exit 12

echo "======> Installing base system"
#pacman -S --needed sudo dosfstools gummiboot efibootmgr iw netctl wpa_supplicant wpa_actiond dialog ifplugd -r ${rootDir}
# TODO: move network config files to this partition
arch-chroot ${rootDir} /distro-config/root-configuration.sh

echo "======> Installing packages"
${mydir}/packages.sh || exit 14

echo "======> Configuring system"
${mydir}/configurations.sh || exit 15

echo "======> Leaving installation environment"
echo "Rebooting in 5 seconds"
echo "Remove install media and remember log in as '${myuser}'"
#mv /tmp/build.log ${rootDir}
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
