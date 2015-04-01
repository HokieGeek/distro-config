#!/bin/sh

lang="en_US.UTF-8"
loc="US/Eastern"

echo "=====> Setting locale"
sed -i "s/#\(${lang}\)/\1/g" /etc/locale.gen
locale-gen

echo LANG=${lang} > /etc/locale.conf
export LANG=${lang}

echo "=====> Setting timezone"
ln -s /usr/share/zoneinfo/${loc} /etc/localtime
hwclock --systohc --utc
