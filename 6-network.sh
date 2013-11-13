#!/bin/sh

pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
ip link
#echo "sudo systemctl enable dhcpcd@<interface>.service"
#echo "sudo systemctl start dhcpcd@<interface>.service"
wifi-menu
systemctl enable net-auto-wireless.service
