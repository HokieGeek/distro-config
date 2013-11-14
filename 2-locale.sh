#!/bin/sh

lang="en_US.UTF-8"
loc="US/Eastern"

echo "=====> Uncomment: ${lang}"
# TODO: just use sed
#vi /etc/locale.gen
cp /{etc,tmp}/locale.gen
sed "s/#\(${lang}\)/\1/g" /tmp/locale.gen > /etc/locale.gen
locale-gen

echo LANG=${lang} > /etc/locale.conf
# TODO: heh, this won't work, huh?
export LANG=${lang}

ln -s /usr/share/zoneinfo/${loc} /etc/localtime
hwclock --systohc --utc
