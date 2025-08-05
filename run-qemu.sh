#!/bin/bash
set -e

if [ ! -f "bzImage" ] || [ ! -f "initramfs.img.gz" ]; then
    echo "❌ Missing bzImage or initramfs.img.gz. Build kernel and initramfs first."
    exit 1
fi

qemu-system-x86_64 -kernel bzImage \
-initrd initramfs.img.gz \
-append "console=ttyS0" -nographic
