pacman -S virtualbox-guest-utils

modprobe -a vboxguest vboxsf vboxvideo

cat << EOF > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF

Add the following line to the top of ~/.xinitrc above any exec options. (create a new file if it does not exist):
cp {$HOME,/tmp}/.xinitrc
sed -i '/bin\/sh/a\
/usr/bin/VBoxClient-all' /tmp/.xinitrc > $HOME/.xinitrc
