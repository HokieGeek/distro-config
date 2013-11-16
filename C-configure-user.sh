#!/bin/sh

mydir=$(cd `dirname $0`; pwd)
myUser=$1
[ $# -gt 2 && "$2" = "--vm" ] && isVm=1 || isVm=0

echo "======> Setting up the network"
${mydir}/6-network.sh --wifi

echo "======> Installing user applications"
${mydir}/7-xtools.sh
${mydir}/8-environment.sh
[ ${isVm} -eq 1 ] && ${mydir}/vm.sh
${mydir}/9-apps.sh

echo "Done. Starting X. Here goes nothing!"
exec startx
