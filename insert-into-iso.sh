#!/bin/sh

here=$(cd `dirname $0`; pwd)
iso=$1
label=$(file ${iso} | awk -F"'" '{ print $2 }' | cut -d' ' -f1)
name=$(basename $iso | sed 's/\(.*\)\.iso/\1/g')

echo "Iso: '${iso}'"
echo "Label: '${label}'"
echo "Name: '${name}'"

mkdir /tmp/${name}

# Mount the iso to temp
sudo mkdir /mnt/arch
sudo mount -o loop ${iso} /mnt/arch
rsync -vr /mnt/arch/* /tmp/${name}
sudo umount /mnt/arch
sudo rm -rf /mnt/arch

# Copy distro-config to the extract directory
rsync -vr --exclude=".git" ${here} /tmp/${name}

# Now create the new iso!
mkisofs -r -V ${label} -cache-inodes -J -l \
    -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -o ${name}-config.iso /tmp/${name}

#mkisofs -r -V ARCH_201310 -cache-inodes -J -l \
#    -b isolinux/isolinux.bin -c isolinux/boot.cat \
#    -no-emul-boot -boot-load-size 4 -boot-info-table \
#    -o archlinux-2013.10.01-dual-config.iso archlinux-2013.10.01

rm -rf /tmp/${name}
