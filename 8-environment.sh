#!/bin/sh

echo "=====> Installing window manager"
sudo pacman -S xmonad xmonad-contrib dzen2 conky dmenu gmrun xcompmgr ttf-dejavu feh

echo "=====> Installing display/login manager"
sudo pacman -S slim slim-themes archlinux-themes-slim
sudo systemctl enable slim.service
# TODO: choose a theme?

echo "=====> Installing incidental applications"
sudo pacman -S terminator dash mlocate acpid wget gnupg
sudo updatedb
sudo rm -rf /bin/sh && sudo ln -s dash /bin/sh

echo "=====> Downloading and setting up dotfiles"
sudo pacman -S git
cd $HOME
git clone https://github.com/HokieGeek/dotfiles.git
dotfiles/setup.sh

echo "=====> Downloading and setting up my ssh keys"
# TODO
#tarball=wget -P ${HOME}/.ssh https://www.dropbox.com/s/24pg53g5onstqut/ssh-keys.tgz.gpg && \
mkdir ${HOME}/.ssh
$(cd $HOME/.ssh && \
    wget -P ${HOME}/.ssh https://www.dropbox.com/s/24pg53g5onstqut/ssh-keys.tgz.gpg && \
    gpg -d ssh-keys.tgz.gpg|tar -xvz)

echo "=====> Enabling suspension on lid closing"
sudo pacman -S acpid
sed -e "s;logger 'LID closed';echo -n mem > /sys/power/state;" /etc/acpi/handler.sh > /tmp/handler.sh
sudo mv /tmp/handler.sh /etc/acpi
# sed -e 's;/usr/share/acpi-support/screenblank;echo -n mem > /sys/power/state;' /tmp/lid.sh > /etc/acpi/lid.sh
# Replace: . /usr/share/acpi-support/screenblank
#    with: echo -n mem > /sys/power/state

echo "=====> Creating profile"
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > ~/.zprofile

echo "=====> Creating xinit"
cat << EOF >> ~/.xinitrc
dropboxd &&
xsetroot -cursor_name left_ptr &&
$HOME/.bin/rotate-wallpaper $HOME/.look/bgs &&
exec xmonad
EOF

