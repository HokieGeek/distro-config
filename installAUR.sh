#!/bin/sh

pkg=`echo $1 | awk -F'/' '{ print $2 }'`

pushd /tmp >/dev/null 3>&1
# wget https://aur.archlinux.org/packages/$1
git clone https://aur.archlinux.org/packages/$1
# tar -xvzf `basename $1`

pushd ${pkg} >/dev/null 2>&1

makepkg -sri
#sudo pacman -U --needed ${pkg}*.tar.xz

popd >/dev/null 2>&1

rm -rf ${pkg}*

popd >/dev/null 2>&1
