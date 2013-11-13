#!/bin/sh

myuser=andres

./1-fs.sh

arch-chroot /mnt

./2-locale.sh &&
./3-packaging.sh &&
./4-user.sh $myuser &&
./5-boot.sh &&

exit

umount /mnt/home
umount /mnt
reboot

./6-network.sh &&
./7-xtools.sh &&
./8-environment.sh &&
./9-apps.sh

echo "Ok. Reboot and log in as '$myuser'"
