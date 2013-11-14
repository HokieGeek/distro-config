#!/bin/sh

echo "=====> Installing window manager"
sudo pacman -S xmonad xmonad-contrib dzen2 conky dmenu gmrun xcompmgr ttf-dejavu feh

echo "=====> Installing display/login manager"
sudo pacman -S slim slim-themes archlinux-themes-slim
systemctl enable slim.service

echo "=====> Installing incidental applications"
sudo pacman -S terminator dash mlocate acpid
sudo updatedb

echo "=====> Downloading and setting up dotfiles"
sudo pacman -S git
cd $HOME
git clone https://github.com/HokieGeek/dotfiles.git
dotfiles/setup.sh

echo "=====> Enabling suspension on lid closing"
sudo pacman -S acpid
cp /{etc/acpi,tmp}/handler.sh
sed -e "s;logger 'LID closed';echo -n mem > /sys/power/state;" /tmp/handler.sh > /etc/acpi/handler.sh
# sed -e 's;/usr/share/acpi-support/screenblank;echo -n mem > /sys/power/state;' /tmp/lid.sh > /etc/acpi/lid.sh
# Replace: . /usr/share/acpi-support/screenblank
#    with: echo -n mem > /sys/power/state

echo "=====> Creating profile"
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > ~/.zprofile

echo "=====> Creating xinit"
cat << EOF >> ~/.xinitrc
dropboxd &&
xsetroot -cursor_name left_ptr &&
exec xmonad
EOF

