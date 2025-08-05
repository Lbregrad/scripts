#!/bin/bash
ARCH=$1
if [ -z "$ARCH" ]; then
    echo "Usage: $0 <architecture>"
    echo "Example: $0 arm"
    exit 1
fi

echo "📦 Installing cross-compilation toolchain for $ARCH..."
sudo apt-get update
case "$ARCH" in
    arm)
        sudo apt-get install gcc-arm-linux-gnueabi ;;
    aarch64)
        sudo apt-get install gcc-aarch64-linux-gnu ;;
    riscv64)
        sudo apt-get install gcc-riscv64-linux-gnu ;;
    *)
        echo "❌ Unsupported architecture: $ARCH"
        exit 1 ;;
esac

echo "✅ Cross-compile toolchain for $ARCH installed."
