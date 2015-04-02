#!/bin/sh

#echo "=====> Updating mirrors list"
# TODO: by speed and status

echo "=====> Updating pacman packages"
sudo sed -i '/#\(\[multilib\]\)/{
s/#\(.*\)/\1/;
N
s/#\(.*\)/\1/;
}' /etc/pacman.conf
sudo pacman -Sy

echo "=====> Installing AUR helper"
pushd /tmp >/dev/null 2>&1
# TODO: Only install if needed
${here}/installAUR.sh pa/package-query/package-query.tar.gz
${here}/installAUR.sh ya/yaourt/yaourt.tar.gz
popd >/dev/null 2>&1
