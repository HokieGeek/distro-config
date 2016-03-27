#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

echo "=====> Creating shell profiles to start X"
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > $HOME/.bash_profile
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > $HOME/.zlogin

echo "=====> Creating xinitrc"
cat << EOF > ~/.xinitrc
#!/bin/sh

syndaemon -k -i 0.8 -d
xrandr --output \`xrandr | awk '\$2 ~ /connected/{ print \$1 }'\` --auto
xsetroot -cursor_name left_ptr
~/.bin/rotate-wallpaper ~/.look/bgs
~/.bin/cvim-server start
snotifyctl start
exec xmonad
EOF

echo "=====> Fix error with non-parenting WM and Java"
# See: https://wiki.archlinux.org/index.php/Java#Applications_not_resizing_with_WM.2C_menus_immediately_closing
sudo echo "export _JAVA_AWT_WM_NONREPARENTING=1" >> /etc/profile.d/jre.sh
