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
cfdisk ${device}
#TODO: take EFI option and select this
# cgdisk ${device}

echo "=====> Creating filesystems"
#TODO: take EFI option and select this
# mkfs.fat -F32 ${boot}
mkfs.ext4 ${root}
mkfs.ext4 ${home}

lsblk ${device}

echo "=====> Mounting partitions"
mkdir ${rootDir}
mount ${root} ${rootDir}
sleep 3s
mkdir ${homeDir}
mount ${home} ${homeDir}

[ ! -d ${homeDir} ] && {
    echo "ERROR: ${homeDir} is not mounted. Aborting."
    exit 5
}

echo "=====> Installing base system"
#rankmirrors -v /etc/pacman.d/mirrorlist
pacstrap ${rootDir} base base-devel
genfstab -U -p ${rootDir} >> ${fstabPath}

echo "=====> Creating swap"
[ ! -e ${swap} ] && fallocate -l ${swapSize} ${rootDir}/${swap}
chmod 0600 ${rootDir}/${swap}
mkswap ${rootDir}/${swap}
swapon ${rootDir}/${swap}
echo "${swap} none swap defaults 0 0" >> ${fstabPath}

cat ${fstabPath}

echo "=====> Installing distro-config scripts to the new system"
cp -r ${here} ${rootDir}
chmod 777 -R ${rootDir}/`basename ${here}`
