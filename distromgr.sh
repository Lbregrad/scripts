#!/bin/bash
# Distro Manager CLI - Full Build & Release Pipeline

VERSION_FILE="VERSION"
CHANGELOG="CHANGELOG.md"
BUILD_DIR="build"
RELEASE_DIR="releases"

# Ensure necessary files exist
mkdir -p $BUILD_DIR $RELEASE_DIR
if [ ! -f "$VERSION_FILE" ]; then
    echo "0.1.0" > $VERSION_FILE
fi
if [ ! -f "$CHANGELOG" ]; then
    echo "# Changelog" > $CHANGELOG
    echo "" >> $CHANGELOG
fi

current_version=$(cat $VERSION_FILE)

# Colors
GREEN="\033[0;32m"
NC="\033[0m"

show_help() {
    echo "Distro Manager CLI"
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  version                Show current version"
    echo "  bump [major|minor|patch]   Bump version"
    echo "  changelog \"message\"        Add entry to changelog"
    echo "  build                  Build kernel, BusyBox, rootfs, initramfs"
    echo "  release \"message\"          Full release: bump patch, update changelog, build, archive, git tag"
    echo "  help                   Show this help"
}

bump_version() {
    part=$1
    IFS='.' read -r major minor patch <<< "$current_version"
    case "$part" in
        major)
            major=$((major + 1)); minor=0; patch=0 ;;
        minor)
            minor=$((minor + 1)); patch=0 ;;
        patch|*)
            patch=$((patch + 1)) ;;
    esac
    new_version="$major.$minor.$patch"
    echo "$new_version" > $VERSION_FILE
    current_version=$new_version
    echo -e "✅ ${GREEN}Version bumped to $new_version${NC}"
}

add_changelog() {
    message="$1"
    date=$(date +"%Y-%m-%d")
    echo "## [$current_version] - $date" >> $CHANGELOG
    echo "- $message" >> $CHANGELOG
    echo "" >> $CHANGELOG
    echo -e "✅ ${GREEN}Added to changelog.${NC}"
}

build_all() {
    echo -e "🔨 ${GREEN}Building Kernel...${NC}"
    ./scripts/fetch-kernel.sh
    ./scripts/build-kernel.sh

    echo -e "🔨 ${GREEN}Building BusyBox...${NC}"
    ./scripts/fetch-busybox.sh
    ./scripts/build-busybox.sh

    echo -e "🔨 ${GREEN}Creating RootFS...${NC}"
    ./scripts/create-rootfs.sh

    echo -e "🔨 ${GREEN}Building Initramfs...${NC}"
    ./scripts/build-initramfs.sh

    mkdir -p $BUILD_DIR
    cp bzImage $BUILD_DIR/
    cp initramfs.img.gz $BUILD_DIR/
    echo -e "✅ ${GREEN}Build completed.${NC}"
}

create_archive() {
    archive_name="distro-$current_version.tar.gz"
    tar -czf "$RELEASE_DIR/$archive_name" -C $BUILD_DIR .
    echo -e "✅ ${GREEN}Release archive created: $RELEASE_DIR/$archive_name${NC}"
}

git_tag_release() {
    git add .
    git commit -m "Release v$current_version"
    git tag -a "v$current_version" -m "Release $current_version"
    echo -e "✅ ${GREEN}Git tagged v$current_version${NC}"
}

release() {
    message="$1"
    bump_version "patch"
    add_changelog "$message"
    build_all
    create_archive
    git_tag_release
    echo -e "🎉 ${GREEN}Release $current_version completed successfully.${NC}"
}

case "$1" in
    version)
        echo "Current version: $current_version"
        ;;
    bump)
        bump_version "$2"
        ;;
    changelog)
        add_changelog "$2"
        ;;
    build)
        build_all
        ;;
    release)
        release "$2"
        ;;
    help|*)
        show_help
        ;;
esac
