#!/bin/sh

lang="en_US.UTF-8"
loc="US/Eastern"

echo "=====> Setting locale"
cp /{etc,tmp}/locale.gen
sed "s/#\(${lang}\)/\1/g" /tmp/locale.gen > /etc/locale.gen
locale-gen

echo LANG=${lang} > /etc/locale.conf
export LANG=${lang}

echo "=====> Setting timezone"
ln -s /usr/share/zoneinfo/${loc} /etc/localtime
hwclock --systohc --utc
