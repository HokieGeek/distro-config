#!/bin/bash

# pacman -Ql netctl || {
    # echo "=====> Installing any needed networking tools"
    pacman -S --needed iw netctl wpa_supplicant wpa_actiond dialog ifplugd
# }

# wired=`iw dev | awk '$0 ~ /Interface/ { print $2 }' | egrep '^e'`
wired=`ip link show | awk -F: '$0 ~ /^[0-9]/ && $2 !~ /lo/ { sub(/\s*/, "", $2); print $2 }' | egrep '^e'`
if [ ! -z "${wired}" ]; then
    echo "=====> Setting up ethernet connection"
    f="/etc/netctl/default/${wired}"
    mkdir -p `dirname $f`
    cp /etc/netctl/examples/ethernet-dhcp ${f}
    sed -i "s/\(Interface=\).*/\1${wired}/g" ${f}
    # dhcpcd ${wired}
    systemctl enable netctl-ifplugd@${wired}.service
    systemctl start netctl-ifplugd@${wired}.service
fi

# wireless=`iw dev | awk '$0 ~ /Interface/ { print $2 }' | egrep '^w'`
wireless=`ip link show | awk -F: '$0 ~ /^[0-9]/ && $2 !~ /lo/ { sub(/\s*/, "", $2); print $2 }' | egrep '^w'`
if [ ! -z "${wireless}" ]; then
    echo "=====> Setting up wireless connection"
    ip link set dev ${wireless} up
    wifi-menu -o
    sleep 2s
    systemctl enable netctl-auto@${wireless}.service
    sleep 5s
    systemctl start netctl-auto@${wireless}.service
    echo "========> Waiting for a fucking eternity for the internet connection to be created"
    sleep 30s
fi
ping -c 3 www.google.com
exit $?
