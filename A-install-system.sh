#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Configuring filesystem"
${mydir}/1-fs.sh ${dev} ${part_root} ${swapfile} ${part_home}

echo "======> Setting up networking"
${mydir}/0-network.sh "--${network}"

echo "======> Installing base system"
arch-chroot ${rootDir} ${mydir}/B-root-setup.sh

echo "======> Leaving installation environment"
echo "Rebooting in 5 seconds"
echo "Remove install media and remember log in as '${myuser}'"
sleep 5s
umount ${homeDir}
sleep 1s
umount ${rootDir}
echo "I've always been in love with you"
sleep 0.5s
reboot
