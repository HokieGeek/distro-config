#!/bin/sh

echo "=====> Installing Xorg Tools"
sudo pacman -S --needed xorg-server xorg-xinit xorg-utils xorg-server-utils xorg-twm xorg-xclock

echo "=====> Installing terminals"
sudo pacman -S --needed xterm terminator screen

echo "=====> Installing video driver"
sudo pacman -S --needed mesa xf86-video-intel lib32-intel-dri lib32-mesa-libgl

echo "=====> Installing audio mixer and touchpad driver"
sudo pacman -S --needed alsa-utils xf86-input-synaptics

echo "=====> Installing window manager"
sudo pacman -S --needed xmonad xmonad-contrib dzen2 conky dmenu gmrun xcompmgr ttf-dejavu terminus-font feh xbacklight

echo "=====> Installing login manager"
sudo pacman -S --needed slim slim-themes archlinux-themes-slim
sed \
    -e '/suspend_cmd/{s/^#\s*//;s:/\(suspend\):/pm-\1:}' \
    -e '/^login_cmd/{s;exec.*session;exec /bin/zsh -l ~/.xinitrc %session;}' \
    -e '/welcome_msg/{s/^#\s*//;s/Welcome.*/Hola/}' \
    -e '/shutdown_msg/{s/^#\s*//;s/The.*ing/Going to bed/}' \
    -e '/reboot_msg/{s/^#\s*//;s/The.*ing/Be right back/}' \
    -e '/current_theme/{s/^#\s*//;s/default/rear-window,mindlock/}' \
    /etc/slim.conf > /tmp/slim.conf
echo "cursor            left_ptr" >> /tmp/slim.conf
    #-e '/default_user/{s/^#\s*//;s/simone/andres/}' \
    #-e '/focus_password/{s/^#\s*//;s/no/yes/}' \
sudo cp /tmp/slim.conf /etc/slim.conf
sudo systemctl enable slim.service

echo "=====> Creating zsh profile"
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > $HOME/.zprofile

echo "=====> Creating xinitrc"
cat << EOF > ~/.xinitrc
#!/bin/sh

xrandr --output \`xrandr | awk '$2~/connected/{ print $1 }'\` --auto
xsetroot -cursor_name left_ptr
~/.bin/rotate-wallpaper ~/.look/bgs
exec xmonad
EOF

