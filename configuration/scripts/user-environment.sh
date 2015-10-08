#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

[ "$1" != "--isagent" ] && {
    echo "=====> Downloading and setting up my ssh keys"
    ssh_keys_tarball="https://www.dropbox.com/s/24pg53g5onstqut/ssh-keys.tgz.gpg"
    ssh_keys_name=`basename ${ssh_keys_tarball}`
    mkdir ${HOME}/.ssh
    cd ${HOME}/.ssh && wget -P ${HOME}/.ssh ${ssh_keys_tarball} && gpg -d ${ssh_keys_name} | tar -xvz && rm -rf ${ssh_keys_name}

    exec ssh-agent ${here}/`basename $0` --isagent $@
}
shift
ssh-add

echo "=====> Downloading and setting up dotfiles"
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

echo "=====> Adding user to various groups"
gpasswd -a 
