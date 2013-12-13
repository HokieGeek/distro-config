#!/bin/sh

here=$(cd `dirname $0`; pwd)

fstabPath=${rootDir}/etc/fstab
swapSize=1024M

echo "=====> Partition the drive(s)"
cgdisk ${device}

echo "=====> Creating filesystems"
[ "${bootloaderType}" = "efi" ] && mkfs.fat -F32 ${part_boot}
mkfs.ext4 ${part_root}
mkfs.ext4 ${part_home}

lsblk ${device}

echo "=====> Mounting partitions"
unmountedHomeDir=${rootDir}/${homeDir}
unmountedBootDir=${rootDir}/${bootDir}
mkdir ${rootDir}
mount ${part_root} ${rootDir}
sleep 3s
mkdir ${unmountedHomeDir}
mount ${part_home} ${unmountedHomeDir}
sleep 3s
mkdir ${unmountedBootDir}
mount ${part_boot} ${unmountedBootDir}

echo "=====> Installing base system"
pacstrap ${rootDir} base base-devel
genfstab -U -p ${rootDir} >> ${fstabPath}

echo "=====> Creating swap"
unmountedSwap=${rootDir}/${swap}
[ ! -e ${swap} ] && fallocate -l ${swapSize} ${unmountedSwap}
chmod 0600 ${unmountedSwap}
mkswap ${unmountedSwap}
swapon ${unmountedSwap}
echo "${swap} none swap defaults 0 0" >> ${fstabPath}

cat ${fstabPath}

echo "=====> Installing distro-config scripts to the new system"
cp -r ${here} ${rootDir}
chmod 777 -R ${rootDir}/`basename ${here}`
