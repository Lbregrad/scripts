#!/bin/bash
PACKAGE_DIR="package"
mkdir -p $PACKAGE_DIR/boot $PACKAGE_DIR/rootfs
cp bzImage $PACKAGE_DIR/boot/
cp initramfs.img.gz $PACKAGE_DIR/boot/
cp VERSION $PACKAGE_DIR/
cp CHANGELOG.md $PACKAGE_DIR/
tar -czf "custom-distro-$(cat VERSION).tar.gz" $PACKAGE_DIR
echo "✅ Packaged custom distro: custom-distro-$(cat VERSION).tar.gz"
