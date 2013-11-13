#!/bin/sh

echo "Updating pacman packages"
cp /{etc,tmp}/pacman.conf
sed '/#\(\[multilib\]\)/{
s/#\(.*\)/\1/;
N
s/#\(.*\)/\1/;
}' /tmp/pacman.conf > /etc/pacman.conf
#sed 's/#\(\[multilib\]\)/\1/g' /tmp/pacman.conf > /etc/pacman.conf
#vi /etc/pacman.conf
pacman -Sy
pacman -S wget

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
