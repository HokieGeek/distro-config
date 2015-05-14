#!/bin/sh

## Add some values which I have now forgotten about but are related to performance
sudo sed -i \
    -e 's/\s*options*/& i915.i915_enable_rc6=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 i915.semaphores=1/' \
    /boot/loader/entries/arch.conf

sudo sed -i \
    -e 's/\s*options*/& quiet loglevel=3 vga=current udev.log-priority=3/' \
    /boot/loader/entries/arch.conf
