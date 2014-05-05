#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Setting up the network"
sudo ${mydir}/0-network.sh || exit 1

echo "======> Installing user applications"
${mydir}/7-xtools.sh ${myuser} || exit 2
${mydir}/8-apps.sh || exit 3
[ ${vm} -eq 1 ] && ${mydir}/vm.sh || exit 4
${mydir}/9-environment.sh || exit 5

echo "Done. Starting X. Here goes nothing!"
exec startx
