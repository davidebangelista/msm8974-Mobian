#!/bin/sh

# Refresh /boot/grub/grub.cfg
update-grub

# Install grub to the ESP
grub-install --target=x86_64-efi --removable /dev/vda

# Fix devicenames in grub.cfg
sed -i 's/vda/sda/g' /boot/grub/grub.cfg
