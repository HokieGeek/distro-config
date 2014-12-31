#!/bin/sh

pkg=`echo $1 | awk -F'/' '{ print $2 }'`

wget https://aur.archlinux.org/packages/$1
tar -xvzf `basename $1`

cd $pkg

makepkg -s
sudo pacman -U --needed ${pkg}*.tar.xz

cd ..

rm -rf ${pkg}*
