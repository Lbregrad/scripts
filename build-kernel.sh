#!/bin/bash
set -e

KERNEL_VERSION=${1:-6.9.7}
KERNEL_DIR="sources/linux-$KERNEL_VERSION"

if [ ! -d "$KERNEL_DIR" ]; then
    echo "❌ Kernel source not found. Run fetch-kernel.sh first."
    exit 1
fi

cd $KERNEL_DIR
make defconfig
make -j$(nproc)
cp arch/x86/boot/bzImage ../../bzImage
echo "✅ Kernel built successfully: bzImage"
