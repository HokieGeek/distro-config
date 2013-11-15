#!/bin/sh

# install yaourt
function installAUR() {
    wget https://aur.archlinux.org/packages/$1
    pkg=`echo $1 | awk -F'/' '{ print $2 }'`
    # echo $pkg
    tar -xvzf `basename $1`
    cd $pkg
    makepkg -s
    pacman -U ${pkg}*.tar.xz
    cd ..
    rm -rf ${pkg}*
}

echo "=====> Installing yaourt"
mkdir /tmp/yaourt
cd /tmp/yaourt
installAUR pa/package-query/package-query.tar.gz
installAUR ya/yaourt/yaourt.tar.gz

echo "=====> Installing chromium and plugins"
sudo yaourt chromium
sudo yaourt pipelight

echo "=====> Installing some system tools"
sudo yaourt openssh rsync

echo "=====> Installing programming tools"
sudo yaourt hg darcs eclipse eclipse-vrapper minicom scons
#arduino

echo "=====> Installing dropbox"
sudo dropbox dropbox-cli

echo "=====> Installing media tools"
sudo yaourt gimp vlc deluge

echo "=====> Installing various useful tools"
sudo yaourt gvim virtualbox nc notify-send
