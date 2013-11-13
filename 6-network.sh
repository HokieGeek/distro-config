#!/bin/sh

interfaceType=$1

[ "${interfaceType}" = "--eth" ] && {
    ip link
    #echo "sudo systemctl enable dhcpcd@<interface>.service"
    #echo "sudo systemctl start dhcpcd@<interface>.service"
}

[ "${interfaceType}" = "--wifi" ] && {
    pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
    wifi-menu
    systemctl enable net-auto-wireless.service
}
