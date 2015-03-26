#!/bin/sh

#here=$(cd `dirname $0`; pwd)

#. ${here}/config.prop

myuser=$1

echo "=====> Installing Xorg tools"
sudo pacman -S --needed xorg-server xorg-xinit xorg-utils xorg-server-utils xorg-twm xorg-xclock xorg-xmessage

echo "=====> Installing terminals"
sudo pacman -S --needed rxvt-unicode tmux reptyr
sudo cat << EOF > /etc/systemd/system/urxvtd@.service
[Unit]
Description=RXVT-Unicode Daemon

[Service]
Type=oneshot
RemainAfterExit=yes
User=%i
ExecStart=/usr/bin/urxvtd -q -f -o

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable urxvtd@${myuser}.service
sudo systemctl start urxvtd@${myuser}.service

exit 42

#echo "=====> Installing file manager"
#sudo pacman -S --needed ranger highlight atool poppler mediainfo w3m

echo "=====> Installing video driver"
sudo pacman -S --needed mesa xf86-video-intel lib32-intel-dri lib32-mesa-libgl

echo "=====> Installing audio mixer and touchpad driver"
sudo pacman -S --needed alsa-utils xf86-input-synaptics

echo "=====> Installing window manager"
sudo pacman -S --needed xmonad xmonad-contrib dzen2 conky dmenu xcompmgr ttf-dejavu terminus-font feh

echo "=====> Installing login manager"
sudo pacman -S --needed slim slim-themes archlinux-themes-slim
sed \
    -e '/suspend_cmd/{s/^#\s*//;s:/\(suspend\):/pm-\1:}' \
    -e '/^login_cmd/{s;exec.*session;exec /bin/zsh -l ~/.xinitrc %session;}' \
    -e '/welcome_msg/{s/^#\s*//;s/Welcome.*/Hola/}' \
    -e '/shutdown_msg/{s/^#\s*//;s/The.*ing/Going to bed/}' \
    -e '/reboot_msg/{s/^#\s*//;s/The.*ing/Be right back/}' \
    -e '/current_theme/{s/^#\s*//;s/default/rear-window/}' \
    -e '/default_user/{s/^#\s*//;s/simone/'${myuser}'/}' \
    -e '/focus_password/{s/^#\s*//;s/no/yes/}' \
    /etc/slim.conf > /tmp/slim.conf
echo "cursor            left_ptr" >> /tmp/slim.conf
sudo cp /tmp/slim.conf /etc/slim.conf
sudo systemctl enable slim.service

echo "=====> Creating zsh profile"
# echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec ssh-agent startx' > $HOME/.zprofile
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > $HOME/.zprofile

echo "=====> Creating xinitrc"
cat << EOF > ~/.xinitrc
#!/bin/sh

syndaemon -k -i 0.8 -d
xrandr --output \`xrandr | awk '\$2 ~ /connected/{ print \$1 }'\` --auto
xsetroot -cursor_name left_ptr
~/.bin/rotate-wallpaper ~/.look/bgs
dropbox start
exec xmonad
EOF

