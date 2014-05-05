#!/bin/bash

pacman -Ql netctl || {
    echo "=====> Installing any needed networking tools"
    pacman -S --needed iw netctl wpa_supplicant wpa_actiond dialog ifplugd
}

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
