#!/bin/bash
ISO_DIR="iso"
mkdir -p $ISO_DIR/boot/grub

# Copy kernel and initramfs
cp bzImage $ISO_DIR/boot/vmlinuz
cp initramfs.img.gz $ISO_DIR/boot/initrd.img

# Create GRUB config
cat > $ISO_DIR/boot/grub/grub.cfg <<EOF
set default=0
set timeout=5
menuentry "Custom Linux" {
    linux /boot/vmlinuz console=ttyS0
    initrd /boot/initrd.img
}
EOF

# Create ISO
grub-mkrescue -o distro.iso $ISO_DIR
echo "✅ Bootable ISO created: distro.iso"
