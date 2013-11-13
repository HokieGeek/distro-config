#!/bin/sh
echo "Setting up the filesystem."
echo "Remember to add tons to /mnt!!"

rootDir=/mnt

root=$1
swap=$2
home=$3

cfdisk /dev/sda

echo "Setting filesystems"
mkfs.ext4 /dev/$1
mkfs.ext4 /dev/$3
mkswap /dev/$2
swapon /dev/$2

lsblk /dev/sda

echo "Mounting partitions"
mkdir ${rootDir}
mkdir ${rootDir}/home
mount /dev/$1 ${rootDir}
mount /dev/$3 ${rootDir}/home

echo "Installing base system"
# vi /etc/pacman.d/mirrolist
rankmirrors -v /etc/pacman.d/mirrorlist
pacstrap -i ${rootDir} base base-devel
genfstab -U -p ${rootDir} >> ${rootDir}/etc/fstab && cat ${rootDir}/etc/fstab
