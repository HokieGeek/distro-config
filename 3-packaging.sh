#!/bin/sh

echo "Uncomment multilib"
vi /etc/pacman.conf
pacman -Sy
rankmirrors -v /etc/pacman.d/mirrorlist
pacman -S wget

# install yaourt
function installAUR() {
    wget https://aur.archlinux.org/packages/$1
    pkg=`echo $1 | awk -F'/' '{ print $2 }'`
    echo $pkg
    tar -xvzf `basename $1`
    cd $pkg
    makepkg -s
    sudo pacman -U ${pkg}*.tar.xz
    cd ..
    rm -rf ${pkg}*
}

{
    mkdir /tmp/yaourt
    cd /tmp/yaourt
    installAUR pa/package-query/package-query.tar.gz
    installAUR ya/yaourt/yaourt.tar.gz
}
