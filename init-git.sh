#!/bin/bash
set -e

if [ ! -d ".git" ]; then
    git init
    git config --global user.name "Your Name"
    git config --global user.email "your@email.com"
    echo ".cache/" >> .gitignore
    echo "build/" >> .gitignore
    echo "initramfs.img.gz" >> .gitignore
    echo "bzImage" >> .gitignore
    echo "modules/" >> .gitignore
    echo "rootfs/" >> .gitignore
    git add .
    git commit -m "Initial commit"
    echo "✅ Git repository initialized."
else
    echo "✔ Git repo already exists."
fi
