#!/bin/sh
echo "=====> Setting up the filesystem."

here=$(cd `dirname $0`; pwd)
rootDir=/mnt
homeDir="${rootDir}/home"

device=$1
root=$2
swap=$3
home=$4

cfdisk /dev/${device}

echo "=====> Setting filesystems"
mkfs.ext4 /dev/${root}
mkfs.ext4 /dev/${home}
mkswap /dev/${swap}
swapon /dev/${swap}

lsblk /dev/${device}

echo "=====> Mounting partitions"
mkdir ${rootDir}
mount /dev/${root} ${rootDir}

mkdir ${homeDir}
mount /dev/${home} ${homeDir}
mkdir ${homeDir}
mount /dev/${home} ${homeDir}

[ ! -d ${homeDir} ] && {
    echo "ERROR: ${homeDir} is not mounted. Aborting."
    exit 5
}

echo "=====> Installing base system"
# TODO: make this an optional thing
#rankmirrors -v /etc/pacman.d/mirrorlist
pacstrap -i ${rootDir} base base-devel
genfstab -U -p ${rootDir} >> ${rootDir}/etc/fstab && cat ${rootDir}/etc/fstab

echo "=====> Installing distro-config scripts to system"
cp -r ${here} /mnt
chmod 777 -R /mnt/`basename ${here}`
