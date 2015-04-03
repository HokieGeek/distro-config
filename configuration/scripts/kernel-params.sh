#!/bin/sh

sudo sed -i \
    's/\s*options*/& i915.i915_enable_rc6=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 i915.semaphores=1' \
    /boot/loader/entries/arch.conf
