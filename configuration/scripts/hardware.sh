#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

echo "=====> Configuring bluetooth"
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

echo "=====> Configuring fan controls"
sudo tee /etc/thinkfan.conf > /dev/null << EOF
sensor /sys/devices/virtual/thermal/thermal_zone0/temp

(0, 0, 40)
(1, 38, 43)
(2, 41, 50)
(3, 44, 50)
(4, 51, 63)
(5, 55, 67)
(7, 61, 32767)
EOF
sudo systemctl enable thinkfan

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

# echo "=====> Setting various power settings"
## These settings were suggested when running powertop command
# Enable Audio codec power management
# sudo echo 1 > /sys/module/snd_hda_intel/parameters/power_save
# sudo echo 0 > /proc/sys/kernel/nmi_watchdog
