#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Setting up the network"
sudo ${mydir}/0-network.sh
#|| exit 30

# Because: shiiiit!
sudo mount -o remount,size=10G,noatime /tmp

echo "======> Updating packaging"
${mydir}/3-packaging.sh || exit 31

echo "======> Installing user applications"
#${mydir}/packageInstaller.?? packages

#echo "======> Applying user configurations"
#echo "======> Applying system configurations"
${mydir}/7-xtools.sh ${myuser} || exit 32
${mydir}/8-apps.sh || exit 33
#[ ${vm} -eq 1 ] && ${mydir}/vm.sh || exit 34
${mydir}/9-environment.sh || exit 35

echo "=====> Updating databases"
sudo updatedb
sudo pkgfile --update

echo "Done. Starting X. Here goes nothing!"
exec startx
