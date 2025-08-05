#!/bin/bash
set -e

KERNEL_VERSION=${1:-6.9.7}
mkdir -p ../f_kernel/sources
cd ../sources

if [ ! -d "linux-$KERNEL_VERSION" ]; then
    echo "📥 Downloading Linux kernel $KERNEL_VERSION..."
    wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$KERNEL_VERSION.tar.xz
    tar -xf linux-$KERNEL_VERSION.tar.xz
    echo "✅ Kernel source ready at sources/linux-$KERNEL_VERSION"
else
    echo "✔ Kernel already downloaded."
fi
