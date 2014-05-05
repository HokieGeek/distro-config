#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Configuring filesystem"
${mydir}/1-fs.sh || exit 1
# ${mydir}/1-fs.sh ${device} ${partRoot} ${partHome} ${partBoot} ${swapfile} ${swapSize} ${rootSize}

echo "======> Setting up networking"
${mydir}/0-network.sh || exit 2

echo "======> Installing base system"
arch-chroot ${rootDir} ${mydir}/B-root-setup.sh || exit 3

echo "======> Leaving installation environment"
echo "Rebooting in 5 seconds"
echo "Remove install media and remember log in as '${myuser}'"
sleep 5s
umount -R ${rootDir}
echo "I've always been in love with you"
sleep 0.5s
reboot
