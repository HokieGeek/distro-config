#!/bin/sh

# install yaourt
function installAUR() {
    wget https://aur.archlinux.org/packages/$1
    pkg=`echo $1 | awk -F'/' '{ print $2 }'`
    echo $pkg
    tar -xvzf `basename $1`
    cd $pkg
    makepkg -s
    pacman -U ${pkg}*.tar.xz
    cd ..
    rm -rf ${pkg}*
}

echo "Installing yaourt"
mkdir /tmp/yaourt
cd /tmp/yaourt
installAUR pa/package-query/package-query.tar.gz
installAUR ya/yaourt/yaourt.tar.gz

sudo yaourt chromium

sudo yaourt pipelight

sudo yaourt minicom openssh rsync

sudo yaourt hg eclipse eclipse-vrapper
#arduino

# TODO: dropbox!
sudo yaourt gvim gimp vlc deluge virtualbox

