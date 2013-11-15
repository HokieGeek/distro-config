#!/bin/sh

device=$1
root=$2
swap=$3
home=$4

here=$(cd `dirname $0`; pwd)
rootDir=/mnt
homeDir=${rootDir}/home
fstabPath=${rootDir}/etc/fstab
swapSize=1024M

echo "=====> Partition the drive(s)"
cgdisk ${device}

echo "=====> Creating swap"
[ ! -e ${swap} ] && fallocate -l ${swapSize} ${swap}
chmod 0600 ${swap}
mkswap ${swap}
swapon ${swap}
# TODO?: echo "${swap} none swap defaults 0 0" >> ${fstabPath}

echo "=====> Creating filesystems"
# mkfs.fat -F32 ${boot}
mkfs.ext4 ${root}
mkfs.ext4 ${home}

lsblk ${device}

echo "=====> Mounting partitions"
mkdir ${rootDir}
mount ${root} ${rootDir}

mkdir ${homeDir}
mount ${home} ${homeDir}
mkdir ${homeDir}
mount ${home} ${homeDir}

[ ! -d ${homeDir} ] && {
    echo "ERROR: ${homeDir} is not mounted. Aborting."
    exit 5
}

echo "=====> Installing base system"
# TODO: make this an optional thing ?
#rankmirrors -v /etc/pacman.d/mirrorlist
pacstrap ${rootDir} base base-devel
genfstab -U -p ${rootDir} >> ${fstabPath} && cat ${fstabPath}

echo "=====> Installing distro-config scripts to system"
cp -r ${here} ${rootDir}
chmod 777 -R ${rootDir}/`basename ${here}`
