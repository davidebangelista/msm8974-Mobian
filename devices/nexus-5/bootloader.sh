#!/bin/sh

DEVICE="$1"

[ "$3" ] || exit 0

gsettings set org.gnome.desktop.interface show-battery-percentage true

gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

ROOTPART=$(grep -vE '^#' /etc/fstab | grep -E '[[:space:]]/[[:space:]]' | awk '{ print $1; }')

pwd=$(cd /lib/linux-image-* && pwd)
KERNEL_VERSION=${pwd#/lib/linux-image-}
echo $KERNEL_VERSION
# SDM845 devices don't have a /boot partition
sed -i '/\/boot/d' /etc/fstab

# Append DTB to kernel
    cat /boot/vmlinuz-${KERNEL_VERSION} /usr/lib/linux-image-${KERNEL_VERSION}/qcom-msm8974-lge-nexus5-hammerhead.dtb > /tmp/kernel-dtb

    # Create the bootimg as it's the only format recognized by the Android bootloader
    mkbootimg --kernel /tmp/kernel-dtb  --ramdisk /boot/initrd.img-${KERNEL_VERSION}  --tags_offset 0x02700000 --kernel_offset 0x00008000 --ramdisk_offset 0x02900000 --pagesize 2048 --cmdline "console=tty0,115200,n8 PMOS_NO_OUTPUT_REDIRECT msm.vram=192m msm.allow_vram_carveout=1 root=${ROOTPART} splash" --base 0x0 --second_offset 0x00f00000 -o /root/boot.img
    
    chmod 777 /root/boot.img
