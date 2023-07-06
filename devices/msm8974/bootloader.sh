#!/bin/sh

DEVICE="$1"

generate_bootimg() {
    UUID="$1"
    SOC="$2"
    VENDOR="$3"
    MODEL="$4"
    VARIANT="$5"

    CMDLINE="console=tty0,115200,n8 PMOS_NO_OUTPUT_REDIRECT msm.vram=192m msm.allow_vram_carveout=1 root=UUID=${UUID} mobile.qcomsoc=${SOC} mobile.vendor=${VENDOR} mobile.model=${MODEL}"
    if [ "${VARIANT}" ]; then
        CMDLINE="${CMDLINE} mobile.variant=${VARIANT}"
        FULLMODEL="${MODEL}-${VARIANT}"
    else
        FULLMODEL="${MODEL}"
    fi
    
    # MSM8974 devices don't have a /boot partition
    sed -i '/\/boot/d' /etc/fstab
    
    # Append DTB to kernel
    echo "Creating boot image for ${FULLMODEL}..."
    cat /boot/vmlinuz-${KERNEL_VERSION} \
        /usr/lib/linux-image-${KERNEL_VERSION}/${SOC}-${VENDOR}-${FULLMODEL}.dtb > /tmp/kernel-dtb

    # Create the bootimg as it's the only format recognized by the Android bootloade
     abootimg --create /bootimg-${FULLMODEL} -c kerneladdr=0x00008000 \
        -c ramdiskaddr=0x2900000 -c secondaddr=0x00f00000 -c tagsaddr=0x2700000 -c pagesize=4096 \
        -c cmdline="mobile.root=UUID=${UUID} ${CMDLINE} ro quiet splash" \
        -k /tmp/kernel-dtb -r /boot/initrd.img-${KERNEL_VERSION}
}

ROOTPART=$(findmnt -n -o UUID /)
KERNEL_VERSION=$(linux-version list)

case "${DEVICE}" in
    "lg-hammerhead")
        generate_bootimg "${ROOTPART}" "qcom-msm8974" "lge" "nexus5-hammerhead"
        ;;
    *)
        echo "ERROR: unsupported device ${DEVICE}"
        exit 1
        ;;
esac
