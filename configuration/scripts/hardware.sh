#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/../config.prop

# echo "=====> Configuring printer"
# sudo hp-setup -i

# TODO: SDD-only {begin}
echo "=====> Change filesystem to noatime for SSDs"
awk '$2 ~ /^\/(home)?$/ { sub(/relatime/, "noatime") } { print }' /etc/fstab > /tmp/fstab && sudo mv /tmp/fstab /etc

echo "=====> Setting disk I/O scheduler for SSDs"
sudo tee /etc/udev/rules.d/60-schedulers.rules > /dev/null << EOF
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/schduler}="noop"
EOF

echo "=====> Setting swapiness to a low value"
echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-sysctl.conf >/dev/null
# TODO: SSD-ONLY {end}

echo "=====> Configuring bluetooth"
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "=====> Configuring fan controls"
sudo tee /etc/thinkfan.conf >/dev/null << EOF
hwmon /sys/devices/virtual/thermal/thermal_zone0/temp

(0, 0, 42)
(1, 40, 47)
(2, 45, 52)
(3, 50, 57)
(4, 55, 62)
(5, 60, 67)
(6, 65, 72)
(7, 70, 77)
(127, 75, 32767)
EOF
sudo systemctl enable thinkfan
sudo systemctl start thinkfan

echo "=====> Configure the TrackPoint"
sudo tee /etc/udev/rules.d/10-trackpoint.rules > /dev/null << EOF
SUBSYSTEM=="serio", DRIVER=="psmouse", WAIT_FOR="/sys/devices/platform/i8042/serio1/serio2/press_to_select", \
WAIT_FOR="/sys/devices/platform/i8042/serio1/serio2/sensitivity", WAIT_FOR="/sys/devices/platform/i8042/serio1/serio2/speed", \
ATTR{press_to_select}="1", ATTR{sensitivity}="200", ATTR{speed}="180"
EOF

sudo tee /etc/X11/xorg.conf.d/20-thinkpad.conf > /dev/null << EOF
Section "InputClass"
    Identifier "Trackpoint Wheel Emulation"
    MatchProduct    "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB TrackPoint pointing device"
    MatchDevicePath "/dev/input/event*"
    Option          "EmulateWheel"          "true"
    Option          "EmulateWheelButton"    "2"
    Option          "Emulate3Buttons"       "false"
    Option          "XAxisMapping"          "6 7"
    Option          "YAxisMapping"          "4 5"
EndSection
EOF

echo "=====> Suspend when battery is low"
sudo tee /etc/udev/rules.d/99-lowbat.rules >/dev/null << EOF
# Suspend the system when battery level drops to 2% or lower
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="2", RUN+="/usr/bin/systemctl suspend"
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="1", RUN+="/usr/bin/systemctl suspend"
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="0", RUN+="/usr/bin/systemctl suspend"
EOF

echo "=====> Add rule to specify nicer dev for the bus pirate"
sudo tee /etc/udev/rules.d/98-buspirate.rules >/dev/null << EOF
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", GROUP="users", MODE="0666", SYMLINK+="buspirate"
EOF

echo "=====> Add rule to specify nicer dev for the Open Logic Sniffer"
sudo tee /etc/udev/rules.d/98-openlogicsniffer.rules >/dev/null << EOF
ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="fc92", MODE="0666", SYMLINK+="ols"
EOF

