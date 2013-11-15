#!/bin/sh

echo "======> Setting up the network"
${mydir}/6-network.sh --wifi

echo "======> Installing user applications"
${mydir}/7-xtools.sh
${mydir}/8-environment.sh
${mydir}/9-apps.sh

echo "Done. Starting X. Here goes nothing!"
exec startx
