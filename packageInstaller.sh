#!/bin/bash

if [ $# -le 0 ]; then
    echo "USAGE: `basename $0` directory ..."
    exit 1
fi

here=$(cd `dirname $0`; pwd)
rootMnt=TODO # FIXME
directories="$@"

for dir in ${directories}; do
    pushd ${dir} >/dev/null 2>&1

    # Install AUR packages
    echo "====> Installing AUR packages"
    for aur-file in `ls -1 *.aur`; do
        for pkg in `cat ${aur-file} | egrep -v '^#'`; do
            echo ":: Installing ${pkg}"
            ${here}/installAUR.sh ${pkg} ${rootMnt}
        done
    done

    # Install all other packages
    echo "====> Installing all packages"
    for file in `ls -1 | grep -v .aur`; do
        if [ "${file:0:1}" == "-" ]; then
            echo ":: Skipping: ${file:1}"
        else
            echo ":: Installing ${file}"
            ${installer} -S --needed `cat ${file} | egrep -v '^#' | xargs` -r ${rootMnt}
        fi
    end

    popd >/dev/null 2>&1
end

