#!/bin/sh

wget -O /librem5-boot.img \
https://arm01.puri.sm/job/u-boot_builds/job/uboot_librem5_build/lastSuccessfulBuild/artifact/output/uboot-librem5/librem5-boot.img

# Copy dtb files to /boot so they can be accessed by u-boot
KERNEL_VERSION=`linux-version list`
/etc/kernel/postinst.d/zz-sync-dtb $KERNEL_VERSION

# Create boot menu file for u-boot
u-boot-update
