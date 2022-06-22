#!/bin/sh

DEBIAN_SUITE=$1
SUITE=$2
CONTRIB=$3
NONFREE=$4

COMPONENTS="main"
[ "$CONTRIB" = "true" ] && COMPONENTS="$COMPONENTS contrib"
[ "$NONFREE" = "true" ] && COMPONENTS="$COMPONENTS non-free"

# Add debian-security for bullseye; note that only the main component is supported
if [ "$DEBIAN_SUITE" = "bullseye" ]; then
    echo "deb http://security.debian.org/ $DEBIAN_SUITE-security $COMPONENTS" >> /etc/apt/sources.list
fi

# Set the proper suite in our sources.list
sed -i "s/@@SUITE@@/${SUITE}/" /etc/apt/sources.list.d/mobian.list

# Setup repo priorities so mobian comes first
cat > /etc/apt/preferences.d/00-mobian-priority << EOF
Package: *
Pin: release o=Mobian
Pin-Priority: 700
EOF
