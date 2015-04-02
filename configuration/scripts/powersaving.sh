#!/bin/sh

echo "=====> Setting various power saving settings"
echo "====> Enable audio codec power management"
echo "options snd_hda_intel power_save=1" | sudo tee /etc/modprobe.d/audio_powersave.conf >/dev/null

echo "====> Disable NMI watchdog"
echo "kernel.nmi_watchdog = 0" | sudo tee /etc/sysctl.d/disable_watchdog.conf >/dev/null

echo "====> Disable bluetooth by default"
sudo tee /etc/udev/rules.d/50-bluetooth.rules >/dev/null << EOF
# Disable bluetooth
SUBSYSTEM=="rfkill", ATTR{type}=="bluetooth", ATTR{state}="0"
EOF

echo "====> Disable Ethernet Wake-on LAN"
sudo tee /etc/udev/rules.d/70-disable_wol.rules >/dev/null << EOF
ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*", RUN+="/usr/bin/ethtool -s %k wol d"
EOF

echo "====> Enable power saving for wifi"
sudo tee /etc/udev/rules.d/70-wifi-powersave.rules >/dev/null << EOF
ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="/usr/bin/iw dev %k set power_save on"
EOF

echo "====> Increasing virtual memory writeback timeout"
echo "vm.dirty_writeback_centisecs = 1500" | sudo tee /etc/sysctl.d/dirty.conf >/dev/null

echo "====> Enabling USB autosuspend"
sudo tee /etc/udev/rules.d/50-usb_power_save.rules >/dev/null << EOF
# If USB devices are failing, go to https://wiki.archlinux.org/index.php/Power_saving#USB_autosuspend
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
EOF

echo "====> Enabling power control for pci devices"
# TODO: is 50 ok?
sudo tee /etc/udev/rules.d/50-pci_pm.rules >/dev/null <<EOF
ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
EOF
#for dev in `lspci | awk '$1 ~ /^00/ { print $1 }'`; do
#    echo 'auto' | sudo tee /sys/bus/pci/devices/0000:${dev}/power/control >/dev/null
#done
