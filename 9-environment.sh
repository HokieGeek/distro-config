#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

[ "$1" != "--isagent" ] && {
    echo "=====> Downloading and setting up my ssh keys"
    sudo pacman -S --needed wget gnupg
    ssh_keys_tarball="https://www.dropbox.com/s/24pg53g5onstqut/ssh-keys.tgz.gpg"
    ssh_keys_name=`basename ${ssh_keys_tarball}`
    mkdir ${HOME}/.ssh
    cd ${HOME}/.ssh && wget -P ${HOME}/.ssh ${ssh_keys_tarball} && gpg -d ${ssh_keys_name} | tar -xvz && rm -rf ${ssh_keys_name}

    exec ssh-agent ${here}/`basename $0` --isagent $@
}
shift
ssh-add

echo "=====> Downloading and setting up dotfiles"
sudo pacman -S --needed git cronie
pushd $HOME 2>&1 >/dev/null
git clone git@github.com:HokieGeek/dotfiles.git
git submodule update --recursive --init
dotfiles/setup.sh

pushd dotfiles/vim/bundle 2>&1 >/dev/null
git submodule update --recursive --init
popd 2>&1 >/dev/null
popd 2>&1 >/dev/null

# Now run some other setup scripts
~/.bin/publishExternalIp --cron
~/.bin/rotate-wallpaper ~/.look/bgs --cron
~/.look/slim/install.sh
sudo systemctl enable cronie.service
sudo systemctl start cronie.service

## TODO: Break this up into different scripts?

echo "=====> Confuring fan controls"
yaourt -S thinkfan lm_sensors

cat << EOF > /tmp/thinkfan.conf
sensor /sys/devices/virtual/thermal/thermal_zone0/temp

(0, 0, 40)
(1, 38, 43)
(2, 41, 50)
(3, 44, 50)
(4, 51, 63)
(5, 55, 67)
(7, 61, 32767)
EOF
sudo mv /tmp/thinkfan.conf /etc
sudo systemctl enable thinkfan

echo "=====> Adjust the TrackPoint"
cat << EOF > /tmp/10-trackpoint.rules
SUBSYSTEM=="serio", DRIVERS=="psmouse", WAIT_FOR="speed", WAIT_FOR="sensitivity", \
ATTR{sensitivity}="200", ATTR{speed}="180"
EOF
sudo mv /tmp/10-trackpoint.rules /etc/udev/rules.d

echo "=====> Suspend when battery is low"
cat << EOF > /tmp/99-lowbat.rules
# Suspend the system when battery level drops to 2% or lower
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="2", RUN+="/usr/bin/systemctl suspend"
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="1", RUN+="/usr/bin/systemctl suspend"
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="0", RUN+="/usr/bin/systemctl suspend"
EOF
sudo mv /tmp/99-lowbat.rules /etc/udev/rules.d

#echo "=====> Installing SD Card driver"
#http://www.realtek.com.tw/DOWNLOADS/RedirectFTPSite.aspx?SiteID=1&DownTypeID=3&DownID=951&PFid=25&Conn=3&FTPPath=ftp%3a%2f%2f208.70.202.219%2fpc%2fcrc%2frts_pstor.tar.bz2
