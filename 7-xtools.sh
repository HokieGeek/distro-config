#!/bin/sh

echo "=====> Installing Xorg Tools"
sudo pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils xorg-twm xorg-xclock xterm

echo "=====> Installing video driver"
sudo pacman -S mesa xf86-video-intel lib32-mesa-libgl

echo "=====> Installing audio mixer and touchpad driver"
sudo pacman -S alsa-utils xf86-input-synaptics
