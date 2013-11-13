#!/bin/sh

sudo pacman -S xmonad xmonad-contrib dzen2 conky dmenu gmrun terminator xcompmgr ttf-dejavu xclip feh

echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > ~/.zprofile

cat << EOF >> ~/.xinitrc
dropboxd &&
xsetroot -cursor_name left_ptr &&
exec xmonad
EOF

# Allow suspend in the sudoers file
%andres ALL=(ALL) NOPASSWD: /usr/sbin/pm-suspend

# Suspend on lid close
vi /etc/acpi/lid.sh
# Replace: . /usr/share/acpi-support/screenblank
#    with: echo -n mem > /sys/power/state
