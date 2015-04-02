#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/configuration/config.prop

# echo "======> Setting up the network"
# sudo ${mydir}/network.sh

echo "======> Running configuration scripts"
for s in `ls ${mydir}/configuration/scripts/*`; do
    ${s}
done

[ ${vm} -eq 1 ] && {
    echo "======> Configuring for VM install"
    ${mydir}/vm.sh || exit 34
}

echo "=====> Updating databases"
sudo updatedb
sudo pkgfile --update
