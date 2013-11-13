#!/bin/sh
echo "Setting up the filesystem."
echo "Remember to add tons to /mnt!!"

rootDir=/mnt

device=$1
root=$2
swap=$3
home=$4

cfdisk ${device}

echo "Setting filesystems"
mkfs.ext4 /dev/${root}
mkfs.ext4 /dev/${home}
mkswap /dev/${swap}
swapon /dev/${swap}

lsblk ${device}

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
