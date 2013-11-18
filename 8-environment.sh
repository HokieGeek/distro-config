#!/bin/sh

sudo pacman -S terminator screen
echo "=====> Downloading and setting up dotfiles"
sudo pacman -S git
cd $HOME
git clone https://github.com/HokieGeek/dotfiles.git
dotfiles/setup.sh

echo "=====> Downloading and setting up my ssh keys"
sudo pacman -S wget gnupg
ssh_keys_tarball="https://www.dropbox.com/s/24pg53g5onstqut/ssh-keys.tgz.gpg"
ssh_keys_name=`basename ${ssh_keys_tarball}`
mkdir ${HOME}/.ssh
$(cd $HOME/.ssh && \
    wget -P ${HOME}/.ssh ${ssh_keys_tarball} && \
    gpg -d ${ssh_keys_name} | tar -xvz && rm -rf ${ssh_keys_name})

echo "=====> Enabling suspension on lid closing"
sudo pacman -S acpid
sed -e "s;logger 'LID closed';echo -n mem > /sys/power/state;" /etc/acpi/handler.sh > /tmp/handler.sh
sudo mv /tmp/handler.sh /etc/acpi
