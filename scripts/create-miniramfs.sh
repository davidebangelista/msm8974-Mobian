#!/bin/sh

export DESTDIR=$(mktemp -d /tmp/miniramfs.XXXXXXXX)
export verbose=n

for dir in bin lib sbin; do
    mkdir -p "${DESTDIR}/usr/${dir}"
    ln -s "usr/${dir}" "${DESTDIR}/${dir}"
done

/usr/share/initramfs-tools/hooks/udev
/usr/share/initramfs-tools/hooks/zz-busybox

cp -a /usr/share/miniramfs/init "${DESTDIR}/"
chmod a+x "${DESTDIR}/init"

cd ${DESTDIR}
find . -print0 | cpio --null --create --format=newc | gzip --best > /boot/miniramfs
