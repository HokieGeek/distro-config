#!/bin/sh

echo "Uncomment: en_US.UTF-8"
vi /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc --utc
