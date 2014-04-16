#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Setting up the network"
${mydir}/0-network.sh --${network}

echo "======> Installing user applications"
${mydir}/6-xtools.sh ${myuser}
${mydir}/7-apps.sh
[ ${vm} -eq 1 ] && ${mydir}/vm.sh
${mydir}/8-environment.sh

echo "Done. Starting X. Here goes nothing!"
exec startx
