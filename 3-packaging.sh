#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

echo "=====> Updating pacman packages"
cp /{etc,tmp}/pacman.conf
sed '/#\(\[multilib\]\)/{
s/#\(.*\)/\1/;
N
s/#\(.*\)/\1/;
}' /tmp/pacman.conf > /etc/pacman.conf
pacman -Sy
