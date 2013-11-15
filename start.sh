#!/bin/sh

mydir=(cd `dirname $0`; pwd)

user=andres

exec ${mydir}/A-install-system.sh ${user}
