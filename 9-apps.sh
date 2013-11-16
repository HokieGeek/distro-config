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
yaourt -S chromium
# Want to make sure that pipelight is installed *after* chromium
yaourt -S pipelight

echo "=====> Installing some system tools"
sudo pacman -S openssh rsync gnu-netcat squashfs-tools

echo "=====> Installing programming tools"
yaourt -S eclipse eclipse-vrapper
# TODO: arduino (the beta isn't working)
# yaourt -S xmonad-darcs
sudo pacman -S mercurial scons minicom

echo "=====> Installing dropbox"
yaourt -S dropbox dropbox-cli
sudo systemctl enable dropbox@HokieGeek
dropbox autostart no

echo "=====> Installing media tools"
sudo pacman -S gimp vlc deluge playonlinux skype

echo "=====> Installing various useful tools"
sudo pacman -S virtualbox googlecl pkgfile x11vnc
sudo pkgfile --update
