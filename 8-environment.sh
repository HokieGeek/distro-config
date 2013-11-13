#!/bin/sh

echo "Installing window manager"
sudo pacman -S xmonad xmonad-contrib dzen2 conky dmenu gmrun xcompmgr ttf-dejavu terminator feh dash
echo "Installing display/login manager"
sudo pacman -S slim slim-themes archlinux-themes-slim
systemctl enable slim.service

echo "Enabling suspension on lid closing"
cp /{etc/acpi,tmp}/lid.sh
sed -e 's;/usr/share/acpi-support/screenblank;echo -n mem > /sys/power/state;' /tmp/lid.sh > /etc/acpi/lid.sh
# Replace: . /usr/share/acpi-support/screenblank
#    with: echo -n mem > /sys/power/state

echo "Creating profile"
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > ~/.zprofile

echo "Creating xinit"
cat << EOF >> ~/.xinitrc
dropboxd &&
xsetroot -cursor_name left_ptr &&
exec xmonad
EOF

