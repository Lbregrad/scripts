#!/bin/bash
DEPS=("gcc" "make" "wget" "cpio" "qemu-system-x86_64" "tar" "git")
missing=0
echo "🔍 Checking dependencies..."
for dep in "${DEPS[@]}"; do
    if ! command -v $dep &> /dev/null; then
        echo "❌ Missing: $dep"
        missing=1
    else
        echo "✔ $dep"
    fi
done
if [ $missing -eq 1 ]; then
    echo "⚠ Please install missing dependencies."
    exit 1
else
    echo "✅ All dependencies are installed."
fi
