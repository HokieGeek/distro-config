#!/bin/bash

if [ $# -le 0 ]; then
    echo "USAGE: $(basename $0) directory ..."
    exit 1
fi

here=$(cd `dirname $0`; pwd)
rootMnt=TODO # FIXME
directories="$@"

for dir in ${directories}; do
    pushd ${dir} >/dev/null 2>&1

    # Install AUR packages
    echo "====> Installing AUR packages"
    for aurfile in $(ls -1 *.aur); do
        for pkg in $(cat ${aurfile} | egrep -v '^#'); do
            echo ":: Installing ${pkg}"
            ${here}/installAUR.sh ${pkg} ${rootMnt}
        done
    done

    # Install all other packages
    echo "====> Installing all packages"
    for file in $(ls -1 | grep -v .aur | grep -v .pkgbuild); do
        if [ "${file:0:1}" == "-" ]; then
            echo ":: Skipping: ${file:1}"
        else
            echo ":: Installing ${file}"
            ${installer} -S --needed $(cat ${file} | egrep -v '^#' | xargs) -r ${rootMnt}
        fi
    done

    # Install my packages
    echo "====> Installing from my PKGBUILDs"
    tempDir=/tmp/$(basename $0).$$
    for file in $(ls -1 | grep .pkgbuild); do
        pkg=$(echo ${file} | sed 's/\.pkgbuild$//')
        echo ":: Found PKGBULD for ${pkg}"
        pkgDir=${tempDir}/${pkg}
        mkdir -p ${pkgDir}
        cp ${file} ${pkgDir}/PKGBUILD
        pushd ${pkgDir}
        namcap PKGBUILD
        makepkg -s
        # sudo pacman -U --needed *.pkg.tar.xz
        ${installer} -U --needed *.pkg.tar.xz -r ${rootMnt}
        popd
    done
    rm -rf ${tempDir}

    popd >/dev/null 2>&1
done

