#!/bin/sh

boottype=$1

### EFI
[ "${boottype}" = "--efi" ] && {
    echo "=====> Installing EFI bootloader"
    mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # ignore if already mounted
    pacman -S grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck
}

### i386
[ "${boottype}" = "--bios" ] && {
    echo "=====> Installing BIOS bootloader"
    pacman -S grub-bios os-prober
    grub-install --target=i386-pc --recheck /dev/sda
}

cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
