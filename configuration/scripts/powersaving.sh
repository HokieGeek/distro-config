#!/bin/sh

echo "=====> Setting various power saving settings"
echo "====> Enable audio codec power management"
echo "options snd_hda_intel powe_save=1" | sudo tee /etc/modprobe.d/audio_powersave.conf >/dev/null

echo "====> Disable NMI watchdog"
echo "kernel.nmi_watchdog = 0" | sudo tee /etc/sysctl.d/disable_watchdog.conf >/dev/null

echo "====> Disable bluetooth by default"
sudo tee /etc/udev/rules.d/50-bluetooth.rules >/dev/null << EOF
# Disable bluetooth
SUBSYSTEM=="rfkill", ATTR{type}=="bluetooth", ATTR{state}="0"
EOF

echo "====> Disable Wake-on LAN"
sudo tee /etc/udev/rules.d/70-disable_wol.rules >/dev/null << EOF
ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*", RUN+="/usr/bin/ethtool -s %k wol d"
EOF

echo "====> Enable power saving for wifi"
sudo tee /etc/udev/rules.d/70-wifi-powersave.rules >/dev/null << EOF
ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="/usr/bin/iw dev %k set power_save on"
EOF


## These settings were suggested when running powertop command
# Enable Audio codec power management
# echo 1 | sudo tee /sys/module/snd_hda_intel/parameters/power_save >/dev/null
# echo 0 | sudo tee /proc/sys/kernel/nmi_watchdog >/dev/null
