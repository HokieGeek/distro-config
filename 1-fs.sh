#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

fstabPath=${rootDir}/etc/fstab

#sgdisk ${device} --zap-all

echo "=====> Partition the drive(s)"
# cgdisk ${device}
[ "${bootloaderType}" == "bios" ] && sgdisk ${device} --new=1:2048:+1007K --typecode=1:ef02
sgdisk ${device} --new=2:0:${rootSize} --largest-new=3
sgdisk ${device} --print

echo "=====> Creating filesystems"
[ "${bootloaderType}" == "efi" ] && mkfs.fat -F32 ${partBoot}
mkfs.ext4 ${partRoot}
mkfs.ext4 ${partHome}

lsblk ${device}

echo "=====> Mounting partitions"
unmountedHomeDir=${rootDir}/${homeDir}
unmountedBootDir=${rootDir}/${bootDir}
mkdir ${rootDir}
mount ${partRoot} ${rootDir}
sleep 3s
mkdir ${unmountedHomeDir}
mount ${partHome} ${unmountedHomeDir}
sleep 3s
mkdir ${unmountedBootDir}
mount ${partBoot} ${unmountedBootDir}

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

# TODO
errors=0
if [ $(lsblk | awk "\$1 ~ /`basename ${partRoot}`/ { print \$NF }") != ${rootDir} ]; then
    errors=1
    echo "ERROR: Did not mount the root partition"
fi
if [ $(lsblk | awk "\$1 ~ /`basename ${partHome}`/ { print \$NF }") != ${homeDir} ]; then
    errors=1
    echo "ERROR: Did not mount the home partition"
fi
if [ $errors -gt 0 ]; then
    exit 1
fi

echo "=====> Installing distro-config scripts to the new system"
cp -r ${here} ${rootDir}
chmod 777 -R ${rootDir}/`basename ${here}`
