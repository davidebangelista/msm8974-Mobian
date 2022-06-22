#!/bin/sh

BOARD="$1"

# Install u-boot to dummy bootsector
dd if=/dev/zero of=/tmp/bootsector.bin bs=8k count=6
TARGET="/usr/lib/u-boot/$BOARD" u-boot-install-sunxi64 -f /tmp/bootsector.bin

# Extract full u-boot binary
dd if=/tmp/bootsector.bin of=/u-boot-sunxi-with-spl.bin bs=8k skip=1

# Copy dtb files to /boot so they can be accessed by u-boot
KERNEL_VERSION=`linux-version list`
/etc/kernel/postinst.d/zz-sync-dtb $KERNEL_VERSION

# Create boot menu file for u-boot
u-boot-update
