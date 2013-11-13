#-- fs --# {{{
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
# }}}

arch-chroot /mnt

#-- locale --# {{{
echo "Uncomment: en_US.UTF-8"
vi /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc --utc
# }}}

#-- packaging --# {{{
echo "Uncomment multilib"
vi /etc/pacman.conf
pacman -Sy
rankmirrors -v /etc/pacman.d/mirrorlist
pacman -S wget

# install yaourt
function installAUR() {
    wget https://aur.archlinux.org/packages/$1
    pkg=`echo $1 | awk -F'/' '{ print $2 }'`
    echo $pkg
    tar -xvzf `basename $1`
    cd $pkg
    makepkg -s
    sudo pacman -U ${pkg}*.tar.xz
    cd ..
    rm -rf ${pkg}*
}

{
    mkdir /tmp/yaourt
    cd /tmp/yaourt
    installAUR pa/package-query/package-query.tar.gz
    installAUR ya/yaourt/yaourt.tar.gz
}
# }}}

#-- user --# {{{
pacman -S sudo bash-completion vim zsh
echo "Set root password: "
passwd
myuser=andres
useradd -m -g users -G wheel,storage,power -s /bin/zsh andres
echo "Set password for '$myuser': "
passwd andres
pacman -Ss sudo

echo "Uncomment this line: '%wheel ALL=(ALL) ALL'"
EDITOR=vim visudo
# }}}

#-- bootloader --# {{{
### EFI
mount -t efivarfs efivarfs /sys/firmware/efi/efivars              # ignore if already mounted
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck

### i386
pacman -S grub-bios os-prober
grub-install --target=i386-pc --recheck /dev/sda


cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
# }}}

exit

umount /mnt/home
umount /mnt
reboot

#-- networking --# {{{
pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
ip link
#echo "sudo systemctl enable dhcpcd@<interface>.service"
#echo "sudo systemctl start dhcpcd@<interface>.service"
wifi-menu
systemctl enable net-auto-wireless.service
# }}}

#-- X tools --# {{{
sudo pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils mesa xf86-video-intel xf86-input-synaptics lib32-mesa-libgl xorg-twm xorg-xclock xterm 
# }}}

#-- Environment --# {{{
sudo pacman -S xmonad xmonad-contrib dzen2 dmenu gmrun zsh terminator xcompmgr alsa-utils ttf-dejavu xclip minicom feh openssh rsync

echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > ~/.zprofile

cat << EOF >> ~/.xinitrc
dropboxd &&
xsetroot -cursor_name left_ptr &&
exec xmonad
EOF
# }}}

#-- Apps --# {{{
sudo yaourt -S pipelight
# }}}

echo "Ok. Reboot and log in as '$myuser'"
