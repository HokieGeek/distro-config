#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

# echo "=====> Change filesystem to noatime for SSDs"
# TODO: needs to be smarter so that it only does this with / and /home
# sudo sed -i 's/relatime/noatime/g' /etc/fstab

## 
## /etc/fstab: static file system information
##
## <file system>	<dir>	<type>	<options>	<dump>	<pass>
## /dev/sda2
#UUID=4fd734f4-0bc9-4f0f-b696-0f5f398880d6	/         	ext4      	rw,noatime,data=ordered	0 1
#
## /dev/sda3
#UUID=2df1cf7b-5dc4-45ed-8292-f8608a4454f7	/home     	ext4      	rw,noatime,data=ordered	0 2
#
## /dev/sda1
#UUID=413A-A44D      	/boot     	vfat      	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro	0 2
#
#/swapfile       	none      	swap      	defaults  	0 0

echo "=====> Configuring bluetooth"
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "=====> Configuring fan controls"
sudo tee /etc/thinkfan.conf > /dev/null << EOF
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
ATTR{press_to_select}="1", ATTR{sensitivity}="230", ATTR{speed}="200"
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
sudo tee /etc/udev/rules.d/99-lowbat.rules > /dev/null << EOF
# Suspend the system when battery level drops to 2% or lower
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="2", RUN+="/usr/bin/systemctl suspend"
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="1", RUN+="/usr/bin/systemctl suspend"
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="0", RUN+="/usr/bin/systemctl suspend"
EOF
