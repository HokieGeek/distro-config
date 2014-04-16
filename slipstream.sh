#!/bin/bash

if [ $# -eq 0 ]; then
    echo "USAGE: `basename $0` <iso> [<usbdev>]"
    exit 0
fi

here=$(cd `dirname $0`; pwd)
iso=$1
[ $# -gt 1 ] && usb=$2 || usb=""
label=$(file ${iso} | awk -F"'" '{ print $2 }' | cut -d' ' -f1)
name=$(basename $iso | sed 's/\(.*\)\.iso/\1/g')
target=/tmp/arch-iso
mount=/mnt/arch

echo "Iso: '${iso}'"
echo "Label: '${label}'"
echo "Name: '${name}'"

mkdir -p ${target}/${name}
cd ${target}
#mkdir 32
#mkdir 64

# Mount the iso to temp
sudo mkdir ${mount}

sudo mount -o loop ${iso} ${mount}
rsync -vr ${mount}/* ${target}/${name}
sudo umount ${mount}

function unsquashAndInstall {
    image=$1
    loc=$2
    unsquash_loc=${loc}/squashfs-root

    mkdir ${loc}
    cd ${loc}
    mv ${image} ${loc}

    echo "image = ${image}"
    echo "loc = ${loc}"

    ## Unsquash
    unsquashfs -d ${unsquash_loc} ${loc}/`basename ${image}`
    sudo mount ${unsquash_loc}/root-image.fs ${mount}

    ## Install the config files
    sudo rsync -vr\
            --exclude=".*" --exclude="*~" --exclude="`basename $0`"\
            ${here} ${mount}

    sudo umount ${mount}

    ## Squash
    mksquashfs ${unsquash_loc} ${image}
}

# Insert into filesystems
unsquashAndInstall ${target}/${name}/arch/x86_64/root-image.fs.sfs ${target}/64
unsquashAndInstall ${target}/${name}/arch/i686/root-image.fs.sfs ${target}/32

# Insert into installation directory
rsync -vr\
            --exclude=".*" --exclude="*~" --exclude="`basename $0`"\
            ${here} ${target}/${name}

sudo rm -rf ${mount}

# Now create the new iso!
mkisofs -r -V ${label} -cache-inodes -J -l \
    -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -o `dirname ${iso}`/${name}-config.iso ${target}/${name}

rm -rf ${target}

# Copy to USB if the option is there
if [ ! -z "$usb" ]; then
    sudo dd bs=4M if=`dirname ${iso}`/${name}-config.iso of=$usb && sync
fi
