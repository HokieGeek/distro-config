#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "=====> Create a new initial RAM disk"
mkinitcpio -p linux

echo "=====> Set root password:"
passwd

echo "=====> Setting hostname '$myhostname'"
echo $myhostname > /etc/hostname

