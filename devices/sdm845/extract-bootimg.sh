#!/bin/sh

DEVICE=$1
IMAGE=$2

[ "$IMAGE" ] || exit 1

case "${DEVICE}" in
    "oneplus6")
        VARIANTS="enchilada fajita"
        ;;
    "pocof1")
        VARIANTS="beryllium-tianma beryllium-ebbg"
        ;;
    *)
        echo "ERROR: unsupported device ${DEVICE}"
        exit 1
        ;;
esac

# SDM845 devices don't have a /boot partition
sed -i '/\/boot/d' ${ROOTDIR}/etc/fstab

for variant in ${VARIANTS}; do
    echo "Extracting boot image for variant ${variant}"
    mv ${ROOTDIR}/bootimg-${variant} ${ARTIFACTDIR}/${IMAGE}.boot-${variant}.img
done
