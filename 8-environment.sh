#!/bin/sh

echo "=====> Installing window manager"
sudo pacman -S xmonad xmonad-contrib dzen2 conky dmenu gmrun xcompmgr ttf-dejavu feh

echo "=====> Installing login manager"
sudo pacman -S slim slim-themes archlinux-themes-slim
sudo systemctl enable slim.service
# TODO: choose a theme?
#slim -p /usr/share/slim/themes/<theme name>
#current_theme (comma delimited means random theme!)
#cp /{etc,tmp}/slim.conf
#sed 's/#\(cursor\s*left_ptr\)/\1/g' /tmp/slim.conf > /etc/slim.conf
# TODO: if this works, you need to edit xinitrc

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
ssh_keys_tarball=wget -P ${HOME}/.ssh https://www.dropbox.com/s/24pg53g5onstqut/ssh-keys.tgz.gpg
ssh_keys_name=`basename ${ssh_keys_tarball}`
mkdir ${HOME}/.ssh
$(cd $HOME/.ssh && \
    wget -P ${HOME}/.ssh ${ssh_keys_tarball} && \
    gpg -d ${ssh_keys_name} | tar -xvz && rm -rf ${ssh_keys_name})

echo "=====> Enabling suspension on lid closing"
sudo pacman -S acpid
sed -e "s;logger 'LID closed';echo -n mem > /sys/power/state;" /etc/acpi/handler.sh > /tmp/handler.sh
sudo mv /tmp/handler.sh /etc/acpi

echo "=====> Creating zsh profile"
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > $HOME/.zprofile

echo "=====> Creating xinitrc"
cat << EOF >> ~/.xinitrc
dropboxd &&
xsetroot -cursor_name left_ptr &&
$HOME/.bin/rotate-wallpaper $HOME/.look/bgs &&
exec xmonad
EOF

