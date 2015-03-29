#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

### EFI
[ "${bootloaderType}" == "efi" ] && {
    echo "=====> Installing EFI bootloader"
    #mount -t efivarfs efivarfs /sys/firmware/efi/efivars

    #pacman -S dosfstools gummiboot
    gummiboot install

    rootPartUUID=`blkid -s PARTUUID -o value ${partRoot}`
    {
        echo -e "title\t\tArch Linux"
        echo -e "linux\t\t/vmlinuz-linux"
        echo -e "initrd\t\t/initramfs-linux.img"
        echo -e "options\t\troot=PARTUUID=${rootPartUUID} rw"

    } > /boot/loader/entries/arch.conf

    #efibootmgr -c -d ${device} -p 1 -l /EFI/gummiboot/gummibootx64.efi -L "Start this shit up"
}


### i386
[ "${bootloaderType}" == "bios" ] && {
    echo "=====> Installing BIOS bootloader"
    pacman -S --needed grub-bios os-prober
    grub-install --target=i386-pc --recheck /dev/sda

    cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    grub-mkconfig -o /boot/grub/grub.cfg
}
