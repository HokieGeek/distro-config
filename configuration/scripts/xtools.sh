#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

echo "=====> Creating shell profiles to start X"
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > $HOME/.bash_profile
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > $HOME/.zlogin

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

