#!/bin/sh

mydir=$(cd `dirname $0`; pwd)

. ${mydir}/config.prop

echo "======> Setting up the network"
${mydir}/6-network.sh --${network}

echo "======> Installing user applications"
${mydir}/7-xtools.sh
${mydir}/8-environment.sh
[ ${isVm} -eq 1 ] && ${mydir}/vm.sh
${mydir}/9-apps.sh

echo "Done. Starting X. Here goes nothing!"
exec startx
