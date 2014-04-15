#!/bin/bash

# Because: shiiiit!
sudo mount -o remount,size=10G,noatime /tmp

# install yaourt
installAUR() {
    pkg=`echo $1 | awk -F'/' '{ print $2 }'`

    wget https://aur.archlinux.org/packages/$1
    tar -xvzf `basename $1`

    cd $pkg

    makepkg -s
    sudo pacman -U ${pkg}*.tar.xz

    cd ..

    rm -rf ${pkg}*
}

echo "=====> Installing AUR helper"
pushd . >/dev/null 2>&1
cd /tmp
installAUR pa/package-query/package-query.tar.gz
installAUR ya/yaourt/yaourt.tar.gz
popd >/dev/null 2>&1

echo "=====> Installing chromium and plugins"
yaourt -S chromium chromium-pepper-flash-stable chromium-libpdf-stable
# Want to make sure that pipelight is installed *after* chromium
yaourt -S pipelight

echo "=====> Installing bluetooth"
sudo pacman -S --needed bluez bluez-utils blueman
sudo systemctl start bluetooth

echo "=====> Installing some system tools"
sudo pacman -S --needed openssh rsync gnu-netcat squashfs-tools dash hdparm evince pm-utils ack the_silver_searcher
sudo rm -rf /bin/sh && sudo ln -s dash /bin/sh
sudo systemctl start sshd && sudo systemctl enable sshd.service

echo "=====> Installing programming tools"
yaourt -S eclipse eclipse-vrapper
# TODO: arduino (the beta isn't working)
# yaourt -S xmonad-darcs
sudo pacman -S --needed mercurial scons minicom apache-ant cmake

echo "=====> Installing dropbox"
yaourt -S dropbox dropbox-cli
sudo systemctl enable dropbox@HokieGeek
dropbox autostart no

echo "=====> Installing firewall"
sudo pacman -S ufw
sudo ufw default deny
sudo ufw allow 192.168.1.0/24
sudo ufw allow SSH
sudo ufw allow VNC
sudo ufw allow Deluge

echo "=====> Installing media tools"
echo "======> Image and Video tools"
sudo pacman -S --needed gimp vlc skype scrot screenfetch inkscape mplayer blender wings3d
yaourt -S libdvdread libdvdcss libdvdnav

echo "======> Audio tools"
sudo pacman -S --needed eject cdparanoia id3 abcde mpd ncmpcpp
yaourt -S google-musicmanager
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
sudo pacman -S --needed hplip cups cups-filters ghostscript gsfonts sane

echo "=====> Installing various useful tools"
sudo pacman -S --needed virtualbox virtualbox-host-modules dkms playonlinux googlecl pkgfile x11vnc colordiff lynx mlocate htop irssi xclip deluge cdrkit
sudo modprobe vboxdrv
sudo updatedb
sudo pkgfile --update

echo "=====> Lastly, games!"
yaourt -S nethack zork1 zork2 zork3
