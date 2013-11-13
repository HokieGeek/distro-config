#!/bin/sh

cfdisk /dev/sda
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
lsblk /dev/sda
mkdir /mnt
mkdir /mnt/home
mount /dev/sda1 /mnt
mount /dev/sda3 /mnt/home

# vi /etc/pacman.d/mirrolist
pacstrap -i /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab && cat /mnt/etc/fstab
