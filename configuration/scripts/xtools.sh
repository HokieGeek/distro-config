#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

echo "=====> Configuring login manager"
sudo sed -i \
    -e '/suspend_cmd/{s/^#\s*//;s:/\(suspend\):/pm-\1:}' \
    -e '/^login_cmd/{s;exec.*session;exec /bin/zsh -l ~/.xinitrc %session;}' \
    -e '/welcome_msg/{s/^#\s*//;s/Welcome.*/Hola/}' \
    -e '/shutdown_msg/{s/^#\s*//;s/The.*ing/Going to bed/}' \
    -e '/reboot_msg/{s/^#\s*//;s/The.*ing/Be right back/}' \
    -e '/current_theme/{s/^#\s*//;s/default/rear-window/}' \
    -e '/default_user/{s/^#\s*//;s/simone/'${myuser}'/}' \
    -e '/focus_password/{s/^#\s*//;s/no/yes/}' \
    /etc/slim.conf
echo "cursor            left_ptr" | sudo tee -a /etc/slim.conf >/dev/null
sudo systemctl enable slim.service

echo "=====> Creating zsh profile"
# echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec ssh-agent startx' > $HOME/.zprofile
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > $HOME/.zprofile

echo "=====> Creating xinitrc"
cat << EOF > ~/.xinitrc
#!/bin/sh

#/usr/X11R6/bin/xautolock -time 10 -locker slock -secure -detectsleep
syndaemon -k -i 0.8 -d
xrandr --output \`xrandr | awk '\$2 ~ /connected/{ print \$1 }'\` --auto
xsetroot -cursor_name left_ptr
~/.bin/rotate-wallpaper ~/.look/bgs
~/.bin/cvim-server start
exec xmonad
EOF

