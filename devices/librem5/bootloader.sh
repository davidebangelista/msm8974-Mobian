#!/bin/sh

BOOTSTART="$1"

wget -O /u-boot-librem5.imx \
https://source.puri.sm/a-wai/uboot-imx/-/jobs/422198/artifacts/raw/debian/output/u-boot.imx

# Re-generate extlinux.conf to ensure we have a valid one
KERNEL_VERSION=$(linux-version list)
/etc/kernel/postinst.d/zz-u-boot-menu "${KERNEL_VERSION}"

TARGET_DISK=$(lsblk -n -o kname,pkname,mountpoint | grep ' /boot$' | awk '{ print $2 }')

# We use parted for adding a "protective" partition for u-boot:
# * mkpart u-boot 66s ${BOOTSTART}: create "u-boot" partition from sector 66
#                                   (33KiB) up to the start of the `/boot`
#                                   partition
# * toggle 3 hidden: set flag "hidden" on partition 3 (the one we just created)

/usr/sbin/parted "/dev/${TARGET_DISK}" -s mkpart u-boot 66s "${BOOTSTART}"
/usr/sbin/parted "/dev/${TARGET_DISK}" -s toggle 3 hidden
