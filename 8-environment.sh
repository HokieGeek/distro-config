#!/bin/sh

echo "Installing window manager"
sudo pacman -S xmonad xmonad-contrib dzen2 conky dmenu gmrun xcompmgr ttf-dejavu terminator feh dash

echo "Enabling suspension on lid closing"
# Suspend on lid close
vi /etc/acpi/lid.sh
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

