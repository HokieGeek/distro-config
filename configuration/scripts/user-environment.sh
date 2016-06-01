#!/bin/sh

here=$(cd `dirname $0`; pwd)

. ${here}/config.prop

[ "$1" != "--isagent" ] && {
    echo "=====> Downloading and setting up my ssh keys"
    curl https://gist.githubusercontent.com/HokieGeek/ed79a96fa8843615689d/raw/0938eb72cc167ec3f26dcde78869207f28c47440/install-ssh-keys.sh | /bin/bash

    exec ssh-agent ${here}/`basename $0` --isagent $@
}
shift
ssh-add

echo "=====> Downloading and setting up dotfiles"
curl https://gist.githubusercontent.com/HokieGeek/ee51363e1e73ac971e85/raw/95357854ed13fed3d53c313d6bc487519fe84290/install-dotfiles.sh | /bin/bash

echo "=====> Downloading and setting up bin"
# TODO: Download the gist?

# Now run some other setup scripts
/usr/local/bin/publishExternalIp --cron
/usr/local/bin/rotate-wallpaper ~/.look/bgs --cron
~/.look/slim/install.sh
sudo systemctl enable cronie.service
sudo systemctl start cronie.service

# echo "=====> Adding user to various groups"
# gpasswd -a 
