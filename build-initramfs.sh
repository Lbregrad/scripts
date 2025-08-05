#!/bin/bash
set -e

cd rootfs
find . | cpio -H newc -o | gzip > ../initramfs.img.gz
echo "✅ Initramfs created: initramfs.img.gz"
