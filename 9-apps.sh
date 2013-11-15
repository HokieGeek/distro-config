#!/bin/bash

# install yaourt
function installAUR {
    wget https://aur.archlinux.org/packages/$1
    pkg=`echo $1 | awk -F'/' '{ print $2 }'`
    # echo $pkg
    tar -xvzf `basename $1`
    cd $pkg
    makepkg -s
    sudo pacman -U ${pkg}*.tar.xz
    cd ..
    rm -rf ${pkg}*
}

echo "=====> Installing AUR helper"
cd /tmp
installAUR pa/package-query/package-query.tar.gz
installAUR ya/yaourt/yaourt.tar.gz

echo "=====> Installing chromium and plugins"
sudo yaourt -S chromium
# Want to make sure that pipelight is installed *after* chromium
sudo yaourt -S pipelight

echo "=====> Installing some system tools"
sudo pacman -S openssh rsync

echo "=====> Installing programming tools"
sudo yaourt -S eclipse eclipse-vrapper
# TODO: darcs
#arduino
sudo pacman -S mercurial scons minicom

echo "=====> Installing dropbox"
sudo yaourt -S dropbox dropbox-cli

echo "=====> Installing media tools"
sudo pacman -S gimp vlc deluge
# TODO: codecs?

echo "=====> Installing various useful tools"
sudo pacman -S virtualbox gnu-netcat
