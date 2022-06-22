#!/bin/sh

DEVICE=$1
IMAGE=$2

[ "$IMAGE" ] || exit 1

# On an Android device, we can't simply flash a full bootable image: we can only
# flash one partition at a time using fastboot.

# Extract rootfs partition
PART_OFFSET=`/sbin/fdisk -lu $IMAGE.img | tail -1 | awk '{ print $2; }'` &&
echo "Extracting rootfs @ $PART_OFFSET"
dd if=$IMAGE.img of=$IMAGE.root.img bs=512 skip=$PART_OFFSET && rm $IMAGE.img

# Filesystem images need to be converted to Android sparse images first
echo "Converting rootfs to sparse image"
img2simg $IMAGE.root.img $IMAGE.root.simg && mv $IMAGE.root.simg $IMAGE.root.img
