#!/bin/sh

echo "=====> Add udev rules to specify nicer dev symlinks for some pluggable devices"
echo "======> Bus Pirate"
sudo tee /etc/udev/rules.d/98-buspirate.rules >/dev/null << EOF
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="A900ftNY", GROUP="users", MODE="0666", SYMLINK+="buspirate"
EOF

echo "======> Open Logic Sniffer"
sudo tee /etc/udev/rules.d/98-openlogicsniffer.rules >/dev/null << EOF
ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="fc92", MODE="0666", SYMLINK+="ols"
EOF

echo "======> FTDI Basic 3.3V & 5V"
sudo tee /etc/udev/rules.d/98-ftdibasic.rules >/dev/null << EOF
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="AL01OVSC", GROUP="users", MODE="0666", SYMLINK+="ftdibasic3v3-A"
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="A506BPQ1", GROUP="users", MODE="0666", SYMLINK+="ftdibasic3v3-B"
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="AH00S8CV", GROUP="users", MODE="0666", SYMLINK+="ftdibasic5v-A"
EOF

echo "======> Arduinos"
sudo tee /etc/udev/rules.d/98-arduino.rules >/dev/null << EOF
SUBSYSTEM=="tty", ATTRS{idProduct}=="6015", ATTRS{idVendor}=="0403", ATTRS{serial}=="ADAOJBOyA", GROUP="users", MODE="0666", SYMLINK+="expresscarduino"
SUBSYSTEM=="tty", ATTRS{idProduct}=="6015", ATTRS{idVendor}=="0403", ATTRS{serial}=="ADAOKII3M", GROUP="users", MODE="0666", SYMLINK+="arduinoMetro328"
SUBSYSTEM=="tty", ATTRS{idProduct}=="0043", ATTRS{idVendor}=="2341", ATTRS{serial}=="64935343533351116090", GROUP="users", MODE="0666", SYMLINK+="arduinoUno"
EOF

echo "=====> Add udev rules for my QMK keyboards"
sudo tee /etc/udev/rules.d/50-qmk-keebs.rules >/dev/null << EOF
# Nyquist
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="cb10", ATTRS{idProduct}=="1156", ENV{DISPLAY}=":0.0", ENV{XAUTHORITY}="/home/andres/.Xauthority", MODE="0666", RUN+="/usr/local/bin/toggle-laptop-kbd off"
ACTION=="remove", SUBSYSTEM=="usb", ATTRS{idVendor}=="cb10", ATTRS{idProduct}=="1156", ENV{DISPLAY}=":0.0", ENV{XAUTHORITY}="/home/andres/.Xauthority", MODE="0666", RUN+="/usr/local/bin/toggle-laptop-kbd on"
SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0037", GROUP="users", MODE="0666"
EOF

sudo udevadm control --reload-rules
