#!/bin/sh
zcat /var/lib/rootfs.tar.gz | tar2sqfs /var/lib/rootfs.sqfs
rm /var/lib/rootfs.tar.gz
