#!/bin/sh

DEVICE=$1
IMAGE=$2

[ "$IMAGE" ] || exit 1

# Strip /boot/efi
sed -i '/\/boot/efi/d' ${ROOTDIR}/etc/fstab

# Create a bootimg
    echo "Creating boot image for Nexus 5 (lg-hammerhead)"
    mv ${ROOTDIR}/root/boot.img ${ARTIFACTDIR}/boot.img
    mv ${ROOTDIR}/root/recovery.img ${ARTIFACTDIR}/recovery.img
