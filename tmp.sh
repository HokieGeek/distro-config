cfdisk /dev/sda
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
lsblk /dev/sda
mkdir /mnt
mkdir /mnt/home
mount /dev/sda1 /mnt
mount /dev/sda3 /mnt/home

# vi /etc/pacman.d/mirrolist
pacstrap -i /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab && cat /mnt/etc/fstab

arch-chroot /mnt
echo "Uncomment: en_US.UTF-8"
vi /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc --utc

echo "Uncomment multilib"
vi /etc/pacman.conf
pacman -Sy

passwd
useradd -m -g users -G wheel,storage,power -s /bin/bash andres
passwd andres
pacman -S sudo bash-completion vim
pacman -Ss sudo

echo "Uncomment this line: '%wheel ALL=(ALL) ALL'"
EDITOR=vim visudo

pacman -S wireless_tools wpa_supplicant wpa_actiond dialog

### EFI
mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # ignore if already mounted
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck

### i386
pacman -S grub-bios os-prober
grub-install --target=i386-pc --recheck /dev/sda


cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg

echo "Exit"

umount /mnt/home
umount /mnt
reboot


ip link
echo "sudo systemctl enable dhcpcd@<interface>.service"
echo "sudo systemctl start dhcpcd@<interface>.service"
echo "wifi-menu"
echo "systemctl enable net-auto-wireless.service"

sudo pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils mesa xf86-video-intel xf86-input-synaptics xorg-twm xorg-xclock xterm
sudo pacman -S xmonad xmonad-contrib dzen2 dmenu gmrun zsh terminator xcompmgr alsa-utils ttf-dejavu wget xclip minicom feh openssh rsync

# Automatic way to install yaourt
sudo pacman -S lib32-mesa-libgl
sudo yaourt -S pipelight

vi ~/.zprofile || ~/.bash_profile
# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

vi ~/.xinitrc
# dropboxd
# xsetroot -cursor_name left_ptr
# exec xmonad
startx
