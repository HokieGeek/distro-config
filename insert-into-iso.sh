#!/bin/sh

#TODO: any way to extract label out of an iso?

mkisofs -r -V ARCH_201310 -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o archlinux-2013.10.01-dual-config.iso archlinux-2013.10.01
