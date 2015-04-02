#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

### EFI
[ "${bootloaderType}" == "efi" ] && {
    echo "=====> Installing EFI bootloader"

    #pacman -S dosfstools gummiboot
    gummiboot install

    rootPartUUID=`blkid -s PARTUUID -o value ${partRoot}`
    {
        echo -e "title\t\tArch Linux"
        echo -e "linux\t\t/vmlinuz-linux"
        echo -e "initrd\t\t/initramfs-linux.img"
        echo -e "options\t\troot=PARTUUID=${rootPartUUID} rw i915.i915_enable_rc6=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 i915.semaphores=1"
        # echo -e "options\t\troot=PARTUUID=${rootPartUUID} rw"

    } > /boot/loader/entries/arch.conf
}


### i386
[ "${bootloaderType}" == "bios" ] && {
    echo "=====> Installing BIOS bootloader"
    pacman -S --needed grub-bios os-prober
    grub-install --target=i386-pc --recheck /dev/sda

    cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    grub-mkconfig -o /boot/grub/grub.cfg
}
