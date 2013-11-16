#!/bin/sh

echo "=====> Installing window manager"
sudo pacman -S xmonad xmonad-contrib dzen2 conky dmenu gmrun xcompmgr ttf-dejavu terminus-font feh xbacklight

echo "=====> Installing login manager"
sudo pacman -S slim slim-themes archlinux-themes-slim
sudo systemctl enable slim.service
cp /{etc,tmp}/slim.conf
sed \
    -e '/suspend_cmd/{s/^#\s*//;s:/\(suspend\):/pm-\1:}' \
    -e '/^login_cmd/{s;exec.*session;exec /bin/zsh -l ~/.xinitrc %session;}' \
    -e '/welcome_msg/{s/^#\s*//;s/Welcome.*/Hola/}' \
    -e '/shutdown_msg/{s/^#\s*//;s/The.*ing/Going to bed/}' \
    -e '/reboot_msg/{s/^#\s*//;s/The.*ing/Be right back/}' \
    -e '/current_theme/{s/^#\s*//;s/default/flat,rear-window,mindlock/}' \
    /tmp/slim.conf > /etc/slim.conf
echo "cursor            left_ptr" >> /etc/slim.conf
    #-e '/default_user/{s/^#\s*//;s/simone/andres/}' \
    #-e '/focus_password/{s/^#\s*//;s/no/yes/}' \

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
cat << EOF > ~/.xinitrc
#!/bin/sh

xrandr --output `xrandr | awk '$2~/connected/{ print $1 }'` --auto
xsetroot -cursor_name left_ptr
~/.bin/rotate-wallpaper ~/.look/bgs
exec xmonad
EOF

