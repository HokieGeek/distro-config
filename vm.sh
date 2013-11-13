/etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
Add the following line to the top of ~/.xinitrc above any exec options. (create a new file if it does not exist):
    ~/.xinitrc
       /usr/bin/VBoxClient-all
