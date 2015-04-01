#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

fstabPath=${rootDir}/etc/fstab

#echo "=====> Partition the drive(s)"
#if [ "${formatter}" == "sgdisk" ]; then
sgdisk ${device} --zap-all
if [ "${bootloaderType}" == "efi" ]; then 
    sgdisk ${device} --new=0:1M:+512M --typecode=1:ef00
else
    sgdisk ${device} --new=0:2048:+1007K --typecode=1:ef02
fi
sgdisk ${device} --new=0:0:${rootSize} --largest-new=3
sgdisk ${device} --print
#elif [ "${formatter}" == "parted" ]; then
#parted ${device} mklabel gpt
#parted ${device} mkpart ESP fat32 1M 513M
#parted ${device} set 1 boot on
#parted ${device} mkpart primary ext4 513M ${rootSize}
#parted ${device} mkpart primary ext4 ${rootSize} 100%
#parted ${device} print
#else
    #echo "Did not recognized formatter: ${formatter}"
    #exit 1
#fi

echo "=====> Creating filesystems"
[ "${bootloaderType}" == "efi" ] && mkfs.vfat -F32 ${partBoot}
mkfs.ext4 ${partRoot}
mkfs.ext4 ${partHome}

lsblk ${device}

echo "=====> Creating swap"
unmountedSwap=${rootDir}/${swapfile}
[ ! -e ${swapfile} ] && fallocate -l ${swapSize} ${unmountedSwap}
chmod 0600 ${unmountedSwap}
mkswap ${unmountedSwap}
swapon ${unmountedSwap}

echo "=====> Mounting partitions"
unmountedHomeDir=${rootDir}/${homeDir}
unmountedBootDir=${rootDir}/${bootDir}

[ ! -f ${rootDir} ] && mkdir ${rootDir}
mount ${partRoot} ${rootDir}
sleep 3s

[ ! -f ${unmountedHomeDir} ] && mkdir ${unmountedHomeDir}
mount ${partHome} ${unmountedHomeDir}
sleep 3s

[ ! -f ${unmountedBootDir} ] && mkdir ${unmountedBootDir}
mount ${partBoot} ${unmountedBootDir}

echo "=====> Installing base system"
# TODO: setup mirrors
pacstrap ${rootDir} base base-devel

echo "=====> Generating fstab"
genfstab -U -p ${rootDir} >> ${fstabPath}
#echo "${swapfile} none swap defaults 0 0" >> ${fstabPath}
cat ${fstabPath}

# TODO
#errors=0
#if [ $(lsblk | awk "\$1 ~ /`basename ${partRoot}`/ { print \$NF }") != ${rootDir} ]; then
#    errors=1
#    echo "ERROR: Did not mount the root partition"
#fi
#if [ $(lsblk | awk "\$1 ~ /`basename ${partHome}`/ { print \$NF }") != ${homeDir} ]; then
#    errors=1
#    echo "ERROR: Did not mount the home partition"
#fi
#if [ $errors -gt 0 ]; then
#    exit 1
#fi

echo "=====> Installing distro-config scripts to the new system"
cp -r ${here} ${rootDir}
chmod 777 -R ${rootDir}/`basename ${here}`
