#!/bin/bash

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

echo "======> Kernel modules"
echo "loop" | sudo tee -a /etc/modules-load.d/modules.conf >/dev/null
echo "vboxdrv" | sudo tee -a /etc/modules-load.d/virtualbox.conf >/dev/null

#echo "=====> Configuring dropbox"
#sudo systemctl enable dropbox@andres
#dropbox-cli start
#dropbox-cli autostart

echo "=====> Configuring shells"
sudo rm -rf /bin/sh
sudo ln -s dash /bin/sh

echo "=====> Configuring SSH"
sudo systemctl start sshd
sudo systemctl enable sshd.service

echo "=====> Setting Google DNS"
sudo tee /etc/resolv.conf > /dev/null << EOF
# Using Google DNS because it's faster
domain home
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

echo "=====> Configuring the firewall"
sudo ufw default deny
sudo ufw allow 192.168.1.0/24
sudo ufw allow SSH
sudo ufw allow VNC
sudo ufw allow Deluge

echo "=====> Configuring MPD"
mkdir ~/music
# TODO: add music
ln -s ~/music ~/.mpd
{
    user=`whoami`
    echo "user \"$user\""
    echo "pid_file \"/home/$user/.mpd/mpd.pid\""
    echo "db_file \"/home/$user/.mpd/mpd.db\""
    echo "state_file \"/home/$user/.mpd/mpdstate\""
    echo "playlist_directory \"/home/$user/.mpd/playlists\""
    echo "music_directory \"/home/$user/.mpd/music\""
} > /tmp/mpd.conf

#cat << EOF >> /tmp/mpd.conf

#audio_output {
    #type        "fifo"
    #name        "my_fifo"
    #path        "/tmp/mpd.fifo"
    #format      "44100:16:2"
#}
#EOF
#sudo mv /tmp/mpd.conf /etc/mpd.conf
#sudo systemctl enable mpd.service
#sudo systemctl start mpd.service

echo "=====> Configuring CUPS"
sudo systemctl start org.cups.cupsd.service
sudo systemctl enable org.cups.cupsd.service
sudo groupadd printadmin
sudo groupadd lp
{
    user=`whoami`
    sudo gpasswd -a ${user} printadmin
    sudo gpasswd -a ${user} lp
}
# /etc/cups/cups-files.conf
# SystemGroup sys root -> SystemGroup sys root printadmin

# /etc/cups/cups-pdf.conf
# #Out /var/spool/cups-pdf/${USER} -> Out ${HOME}

sudo systemctl restart org.cups.cupsd.service

# echo "=====> Configuring virtualbox"
# sudo modprobe vboxdrv

echo "=====> Add service that assures wifi restarts after resume"
sudo tee /etc/systemd/system/netctl-auto-resume@.service > /dev/null << EOF
[Unit]
Description=restart netctl-auto on resume.
Requisite=netctl-auto@%i.service
After=suspend.target

[Service]
Type=oneshot
ExecStart=/usr/bin/systemctl restart netctl-auto@%i.service

[Install]
WantedBy=suspend.target
EOF
