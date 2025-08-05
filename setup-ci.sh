#!/bin/bash
set -e

echo "📦 Setting up GitHub Actions CI pipeline..."

mkdir -p .github/workflows

cat > .github/workflows/build.yml << 'EOF'
name: Build and Test Distro

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-22.04

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y build-essential bison flex libncurses5-dev libssl-dev \
          bc wget curl git cpio xz-utils qemu-system-x86 grub-pc-bin grub-common \
          xorriso

    - name: Show version
      run: ./scripts/distromgr.sh version

    - name: Build Kernel & RootFS
      run: ./scripts/distromgr.sh build

    - name: Create Bootable ISO
      run: ./scripts/make-iso.sh

    - name: Test Boot with QEMU
      run: |
        timeout 20s qemu-system-x86_64 \
          -kernel bzImage \
          -initrd initramfs.img.gz \
          -append "console=ttyS0" -nographic || true

    - name: Upload build artifacts
      uses: actions/upload-artifact@v3
      with:
        name: distro-artifacts
        path: |
          bzImage
          initramfs.img.gz
          distro.iso
          VERSION
          CHANGELOG.md
EOF

echo "✅ GitHub Actions CI workflow created at .github/workflows/build.yml"
