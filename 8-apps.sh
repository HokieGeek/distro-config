#!/bin/bash

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

echo "=====> Installing some user stuff"
sudo pacman -S --needed bash-completion gvim zsh

# Because: shiiiit!
sudo mount -o remount,size=10G,noatime /tmp

echo "=====> Installing AUR helper"
sudo pacman -S --needed wget
pushd /tmp >/dev/null 2>&1
# TODO: Only install if needed
${here}/installAUR.sh pa/package-query/package-query.tar.gz
${here}/installAUR.sh ya/yaourt/yaourt.tar.gz
popd >/dev/null 2>&1

echo "=====> Installing browser and plugins"
yaourt -S --needed google-chrome icedtea-web ttf-liberation ttf-google-fonts-git

echo "=====> Installing bluetooth"
sudo pacman -S --needed bluez bluez-utils
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

echo "=====> Installing some system tools"
sudo pacman -S --needed openssh rsync gnu-netcat squashfs-tools dash hdparm evince pm-utils ack the_silver_searcher dos2unix
sudo rm -rf /bin/sh && sudo ln -s dash /bin/sh
sudo systemctl start sshd && sudo systemctl enable sshd.service

echo "=====> Installing programming tools"
yaourt -S --needed eclipse eclipse-vrapper jslint go jdk7-openjdk ctags android-studio android-sdk-platform-tools
# TODO: arduino (the beta isn't working)
sudo pacman -S --needed mercurial scons minicom apache-ant cmake

echo "=====> Installing dropbox"
yaourt -S --needed dropbox dropbox-cli
#sudo systemctl enable dropbox@HokieGeek
#dropbox autostart no

echo "=====> Installing firewall"
sudo pacman -S ufw
sudo ufw default deny
sudo ufw allow 192.168.1.0/24
sudo ufw allow SSH
sudo ufw allow VNC
sudo ufw allow Deluge

echo "=====> Installing media tools"
echo "======> Image and Video tools"
sudo pacman -S --needed gimp vlc skype scrot screenfetch inkscape mplayer blender wings3d cheese
# GIMP ARROW PLUGIN: http://www.programmer97.talktalk.net/Files/arrow.zip
yaourt -S --needed libdvdread libdvdcss libdvdnav

echo "======> Audio tools"
sudo pacman -S --needed eject cdparanoia id3 abcde mpd ncmpcpp
yaourt -S --needed google-musicmanager
mkdir ~/music
# TODO: add music
ln -s ~/music ~/.mpd
{
    user=`whoami`
    echo "user \"$user\""
    echo "pid_file \"/home/$user/.mpd/mpd.pid\""
    echo "db_file \"/home/$user/.mpd/mpd.db\""
    echo "state_file \"/home/$user/.mpd/mpdstate\""
    echo "playlist_directory \"/home/$user/.mpd/playlists\""
    echo "music_directory \"/home/$user/.mpd/music\""
} > /tmp/mpd.conf

#cat << EOF >> /tmp/mpd.conf

#audio_output {
    #type        "fifo"
    #name        "my_fifo"
    #path        "/tmp/mpd.fifo"
    #format      "44100:16:2"
#}
#EOF
sudo mv /tmp/mpd.conf /etc/mpd.conf
sudo systemctl enable mpd.service
sudo systemctl start mpd.service

echo "=====> Installing printer stuff"
sudo pacman -S --needed cups cups-filters cups-pdf bluez-cups ghostscript gsfonts sane
sudo pacman -S --needed hplip
sudo systemctl start org.cups.cupsd.service
sudo systemctl enable org.cups.cupsd.service
sudo groupadd printadmin
sudo groupadd lp
{
    user=`whoami`
    sudo gpasswd -a ${user} printadmin
    sudo gpasswd -a ${user} lp
}
# /etc/cups/cups-files.conf
# SystemGroup sys root -> SystemGroup sys root printadmin

# /etc/cups/cups-pdf.conf
# #Out /var/spool/cups-pdf/${USER} -> Out ${HOME}

sudo systemctl restart org.cups.cupsd.service

echo "=====> Installing various useful tools"
sudo pacman -S --needed virtualbox virtualbox-host-modules dkms playonlinux googlecl pkgfile x11vnc colordiff lynx mlocate htop irssi xclip deluge cdrkit lsof acpi
sudo modprobe vboxdrv
sudo updatedb
sudo pkgfile --update

echo "=====> Lastly, games!"
yaourt -S --needed nethack zork1 zork2 zork3 gnugo vassal
