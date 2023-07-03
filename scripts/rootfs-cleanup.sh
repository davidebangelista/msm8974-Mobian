#!/bin/sh

# Remove apt packages which are no longer unnecessary and delete
# downloaded packages
apt -y autoremove --purge
apt clean

# Remove machine ID so it gets generated on first boot
rm -f /var/lib/dbus/machine-id
echo uninitialized > /etc/machine-id

# FIXME: these are automatically installed on first boot, and block
# the system startup for over 1 minute! Find out why this happens and
# avoid this nasty hack
rm -f /lib/systemd/system/wpa_supplicant@.service \
      /lib/systemd/system/wpa_supplicant-wired@.service \
      /lib/systemd/system/wpa_supplicant-nl80211@.service
