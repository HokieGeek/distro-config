#!/bin/sh

interfaceType=$1

[ "${interfaceType}" = "--eth" ] && {
    [ "$#" -eq 1 ] && {
        intf=`ip link | cut -d: -f2 | egrep -v "(00|lo)" | cut -d' ' -f2`
        echo "=====> Setting up ethernet connection"
        systemctl enable dhcpcd@${intf}.service
        systemctl start dhcpcd@${intf}.service
    }
}

[ "${interfaceType}" = "--wifi" ] && {
    [ "$2" = "--install" ] && {
        pacman -S --needed iw wpa_supplicant wpa_actiond dialog ifplugd
    } || {
        echo "=====> Setting up wireless connection"
        # intf=`iw dev | cut -d: -f2 | egrep -v "(00|lo)" | cut -d' ' -f2`
        intf=`iw dev | awk '$0 ~ /Interface/ { print $2 }'`

        # TODO: select SSID and enter PWD
        iw dev ${intf} scan | grep SSID

        # ip link set dev ${intf} up
        # iw dev ${intf} connect <SSID> key 0:<PWD>
        # dhcpd ${intf}

# echo "ExecStart=/usr/bin/iw dev %i connect <SSID> key 0:<PWD>" >> $servicefile
        cat << EOF >/etc/systemd/system/wifi@.service
[Unit]
Description=Wifi connectivity (%i)
Wants=network.target
Before=network.target
BindsTo=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
RemainAfterExit=yes

ExecStart=/usr/bin/ip link set dev %i up
ExecStart=/usr/bin/wifi_connect
ExecStart=/usr/bin/dhcpcd %i

ExecStop=/usr/bin/ip link set dev %i down

[Install]
WantedBy=multi-user.target
EOF

        systemctl enable wifi@${intf}.service
        systemctl start wifi@${intf}.service
        iw dev ${intf} link
    }
}

ping -c 3 www.google.com
# TODO: exit if this ping fails
