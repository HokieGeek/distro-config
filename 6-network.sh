#!/bin/sh

interfaceType=$1

[ "${interfaceType}" = "--eth" ] && {
    intf=`ip link | cut -d: -f2 | egrep -v "(00|lo)" | cut -d' ' -f2`
    echo "=====> Setting up ethernet connection"
    sudo systemctl enable dhcpcd@${intf}.service
    sudo systemctl start dhcpcd@${intf}.service
}

[ "${interfaceType}" = "--wifi" ] && {
    echo "=====> Setting up wireless connection"
    pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
    wifi-menu
    systemctl enable net-auto-wireless.service
}
