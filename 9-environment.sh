#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

echo "=====> Downloading and setting up my ssh keys"
sudo pacman -S --needed wget gnupg
ssh_keys_tarball="https://www.dropbox.com/s/24pg53g5onstqut/ssh-keys.tgz.gpg"
ssh_keys_name=`basename ${ssh_keys_tarball}`
mkdir ${HOME}/.ssh
$(cd $HOME/.ssh && \
    wget -P ${HOME}/.ssh ${ssh_keys_tarball} && \
    gpg -d ${ssh_keys_name} | tar -xvz && rm -rf ${ssh_keys_name})

#exit 42

echo "=====> Downloading and setting up dotfiles"
sudo pacman -S --needed git cronie
cd $HOME
git clone https://github.com/HokieGeek/dotfiles.git
git submodule update --recursive --init
dotfiles/setup.sh
~/.bin/publishExternalIp --cron
~/.bin/rotate-wallpaper ~/.look/bgs --cron
sudo systemctl enable cronie.service
sudo systemctl start cronie.service

echo "=====> Enabling suspension on lid closing"
# sudo pacman -S --needed acpid
# sed -e "s;logger 'LID closed';echo -n mem > /sys/power/state;" /etc/acpi/handler.sh > /tmp/handler.sh
# sudo mv /tmp/handler.sh /etc/acpi

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
