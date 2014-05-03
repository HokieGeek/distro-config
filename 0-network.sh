#!/bin/bash

if [ `pacman -Q1 netctl` -eq 1 -o `pacman -Q1 iw` -eq 1 ]; then
    echo "=====> Installing networking tools"
    pacman -S --needed netctl iw wpa_supplicant wpa_actiond dialog ifplugd
fi

wired=`iw dev | awk '$0 ~ /Interface/ { print $2 }' | egrep '^e'`
if [ ! -z "${wired}" ]; then
    echo "=====> Setting up ethernet connection"
    f="/etc/netctl/default/${wired}"
    cp /etc/netctl/examples/ethernet-dhcp ${f}
    sed -i "s/\(Interface=\).*/\1${wired}/g" ${f}
    systemctl enable netctl-ifplugd@${wired}.service
    systemctl start netctl-ifplugd@${wired}.service
fi

wireless=`iw dev | awk '$0 ~ /Interface/ { print $2 }' | egrep '^w'`
if [ ! -z "${wireless}" ]; then
    echo "=====> Setting up wireless connection"
    ip link set dev ${wireless} up
    wifi-menu -o
    systemctl enable netctl-auto@${wireless}.service
    systemctl start netctl-auto@${wireless}.service
fi
ping -c 3 www.google.com
exit $?
