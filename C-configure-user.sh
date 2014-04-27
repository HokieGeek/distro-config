#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Setting up the network"
sudo ${mydir}/0-network.sh --${network}

echo "======> Installing user applications"
${mydir}/7-xtools.sh ${myuser}
${mydir}/8-apps.sh
[ ${vm} -eq 1 ] && ${mydir}/vm.sh
${mydir}/9-environment.sh

echo "Done. Starting X. Here goes nothing!"
exec startx
