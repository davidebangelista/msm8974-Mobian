#!/bin/sh

set -e

DEVICE="$1"

case "$DEVICE" in
    "pinephonepro") 
        BOARD="pinephone-pro-rk3399"
        ;;
    *) 
        echo "Unknown device $DEVICE"
        exit 1
        ;;
esac


# Install u-boot to dummy bootsector
dd if=/dev/zero of=/tmp/bootsector.bin bs=1M count=12
TARGET="/usr/lib/u-boot/$BOARD" u-boot-install-rockchip /tmp/bootsector.bin

# Extract full u-boot binary
dd if=/tmp/bootsector.bin of=/u-boot-rockchip-with-spl.bin bs=32k skip=1

# Copy dtb files to /boot so they can be accessed by u-boot
KERNEL_VERSION=`linux-version list`
/etc/kernel/postinst.d/zz-sync-dtb $KERNEL_VERSION

# Create boot menu file for u-boot
u-boot-update
