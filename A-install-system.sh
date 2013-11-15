#!/bin/sh

mydir=(cd `dirname $0`; pwd)
myuser=$1
root=/mnt

echo "======> Configuring filesystem"
dev=/dev/sda
part_root=/dev/sda1
part_home=/dev/sda2
swapfile=/swapfile
${mydir}/1-fs.sh ${dev} ${part_root} ${swapfile} ${part_home}

echo "======> Installing base system"
arch-chroot ${rootDir} ${mydir}/B-root-setup.sh ${myuser}

echo "======> Leaving installation environment"
echo "Rebooting in 5 seconds"
echo "Remove install media and remember log in as '$myuser'"
sleep 4s
umount ${homeDir}
umount ${rootDir}
echo "I've always been in love with you"
sleep 0.5s
reboot

