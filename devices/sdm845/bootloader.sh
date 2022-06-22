#!/bin/sh

DEVICE="$1"
OFFSET=0

ROOTPART=$(grep -vE '^#' /etc/fstab | grep -E '[[:space:]]/[[:space:]]' | awk '{ print $1; }')
KERNEL_VERSION=$(linux-version list)

# Update the initramfs to make sure it's up-to-date
update-initramfs -u -k all

case "${DEVICE}" in
    "oneplus6")
        DTB_VENDOR="oneplus"
        DTB_VARIANTS="enchilada fajita"
        ;;
    "pocof1")
        DTB_VENDOR="xiaomi"
        DTB_VARIANTS="beryllium-tianma beryllium-ebbg"
        ;;
    *)
        echo "ERROR: unsupported device ${DEVICE}"
        exit 1
        ;;
esac

# Create a bootimg for each variant
for variant in ${DTB_VARIANTS}; do
    echo "Creating boot image for variant ${variant}"

    # Append DTB to kernel
    cat /boot/vmlinuz-${KERNEL_VERSION} /usr/lib/linux-image-${KERNEL_VERSION}/qcom/sdm845-${DTB_VENDOR}-${variant}.dtb > /tmp/kernel-dtb

    # Create the bootimg as it's the only format recognized by the Android bootloader
    mkbootimg --kernel /tmp/kernel-dtb --ramdisk /boot/initrd.img-${KERNEL_VERSION} \
        --kernel_offset 0x8000 --ramdisk_offset 0x1000000 --tags_offset 0x100 \
        --pagesize 4096 --cmdline "mobian.root=${ROOTPART} mobian.vendor=${DTB_VENDOR} mobian.variant=${variant} init=/sbin/init rw quiet splash" \
        --base 0x0 --second_offset 0x0 -o /bootimg-${variant}
done
