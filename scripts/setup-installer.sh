#!/bin/sh

USERNAME=$1
[ "$USERNAME" ] || exit 1

# Disable power key handling to avoid accidental shutdown mid-install
mkdir -p /etc/systemd/logind.conf.d
cat > /etc/systemd/logind.conf.d/10-ignore-power-key.conf << EOF
[Login]
HandlePowerKey=ignore
EOF

# Setup ondevice installer to start on boot
systemctl enable calamaresfb.service

# Disable eg25-manager (we don't need the modem during install)
systemctl disable eg25-manager.service

# Rename user so installer can change it's password
if [ -f /etc/calamares/modules/mobile.conf ] && [ "$USERNAME" != "mobian" ]; then
    sed -i "s/username: \"mobian\"/username: \"$USERNAME\"/" /etc/calamares/modules/mobile.conf
fi
