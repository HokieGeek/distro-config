#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/configuration/config.prop

### EFI
[ "${bootloaderType}" == "efi" ] && {
    echo "=====> Installing EFI bootloader"

    gummiboot install

    ## Creatre a default config
    rootPartUUID=`blkid -s PARTUUID -o value ${partRoot}`
    {
        echo -e "title\t\tArch Linux"
        echo -e "linux\t\t/vmlinuz-linux"
        echo -e "initrd\t\t/initramfs-linux.img"
        echo -e "options\t\troot=PARTUUID=${rootPartUUID} rw"

    } > /boot/loader/entries/arch.conf
}


### i386
[ "${bootloaderType}" == "bios" ] && {
    echo "=====> Installing BIOS bootloader"
    grub-install --target=i386-pc --recheck /dev/sda

    cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    grub-mkconfig -o /boot/grub/grub.cfg
}
