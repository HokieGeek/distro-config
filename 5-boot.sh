#!/bin/sh

boottype=$1
root=$2

### EFI
[ "${boottype}" = "--efi" ] && {
    echo "=====> Installing EFI bootloader"
    mount -t efivarfs efivarfs /sys/firmware/efi/efivars

    pacman -S gummiboot
    gummiboot install

    {
        echo -e "title\t\tArch Linux"
        echo -e "linux\t\t/vmlinuz-linux"
        echo -e "initrd\t\t/initramfs-linux.img"
        echo -e "options\t\troot=${root} rw"

    } > /boot/loader/entries/arch.conf

    #pacman -S --needed grub efibootmgr
    #grub-install --target=x86_64-efi --efi-directory=/boot \
                 #--bootloader-id=arch_grub --recheck
}


### i386
[ "${boottype}" = "--bios" ] && {
    echo "=====> Installing BIOS bootloader"
    pacman -S --needed grub-bios os-prober
    grub-install --target=i386-pc --recheck /dev/sda

    cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    grub-mkconfig -o /boot/grub/grub.cfg
}
