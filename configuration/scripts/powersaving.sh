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

# echo "====> VM writeback timeout"

# echo "====> Enabling SATA link power management"

# echo "====> Enabling autosuspend for some USB devices"

# echo "====> Enabling power control for pci devices"
# TODO: use lspci to determine which?
# echo 'auto' > /sys/bus/pci/devices/0000:00:??.?/power/control
#00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
#00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core processor Graphics Controller (rev 09)
#00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
#00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
#00:16.3 Serial controller: Intel Corporation 7 Series/C210 Series Chipset Family KT Controller (rev 04)
#00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (rev 04)
#00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
#00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
#00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
#00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4)
#00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
#00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
#00:1f.0 ISA bridge: Intel Corporation QM77 Express Chipset LPC Controller (rev 04)
#00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
#00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
#02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5229 PCI Express Card Reader (rev 01)
#03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] (rev 34)
