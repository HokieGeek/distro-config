#!/bin/sh

interfaceType=$1

[ "${interfaceType}" = "--eth" ] && {
    [ "$#" -eq 1 ] && {
        intf=`ip link | cut -d: -f2 | egrep -v "(00|lo)" | cut -d' ' -f2`
        echo "=====> Setting up ethernet connection"
        sudo systemctl enable dhcpcd@${intf}.service
        sudo systemctl start dhcpcd@${intf}.service
    }


[ "${interfaceType}" = "--wifi" ] && {
    [ "$2" = "--install" ] && {
        pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
    } || {
        echo "=====> Setting up wireless connection"
        intf=`iw dev | cut -d: -f2 | egrep -v "(00|lo)" | cut -d' ' -f2`
        ip link set ${intf} up
        wifi-menu ${intf}
        systemctl enable net-auto-wireless.service
    }
}

ping -c 3 www.google.com
