sudo pacman -S virtualbox-guest-utils

sudo modprobe -a vboxguest vboxsf vboxvideo

cat << EOF > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF
cp /tmp/virtualbox.conf /etc/modules-load.d

#Add the following line to the top of ~/.xinitrc above any exec options. (create a new file if it does not exist):
sed -i '/bin\/sh/a /usr/bin/VBoxClient-all' $HOME/.xinitrc
