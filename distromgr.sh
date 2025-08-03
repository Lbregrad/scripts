#!/bin/bash
# Distro Manager CLI
# Features: version bumping, changelog updating

CHANGELOG="CHANGELOG.md"
VERSION_FILE="VERSION"

# Ensure files exist
if [ ! -f "$VERSION_FILE" ]; then
    echo "0.1.0" > $VERSION_FILE
fi
if [ ! -f "$CHANGELOG" ]; then
    echo "# Changelog" > $CHANGELOG
    echo "" >> $CHANGELOG
fi

current_version=$(cat $VERSION_FILE)

function show_help() {
    echo "Distro Manager CLI"
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  version         Show current version"
    echo "  bump [major|minor|patch]  Bump version"
    echo "  changelog \"message\"       Add entry to changelog"
    echo "  release \"message\"         Bump patch + changelog"
    echo "  help            Show this help"
}

function show_version() {
    echo "Current version: $current_version"
}

function bump_version() {
    part=$1
    IFS='.' read -r major minor patch <<< "$current_version"
    case "$part" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch|*)
            patch=$((patch + 1))
            ;;
    esac
    new_version="$major.$minor.$patch"
    echo "$new_version" > $VERSION_FILE
    echo "✅ Version bumped to $new_version"
}

function add_changelog() {
    message="$1"
    date=$(date +"%Y-%m-%d")
    echo "## [$current_version] - $date" >> $CHANGELOG
    echo "- $message" >> $CHANGELOG
    echo "" >> $CHANGELOG
    echo "✅ Added to changelog."
}

function release() {
    message="$1"
    bump_version "patch"
    current_version=$(cat $VERSION_FILE)
    date=$(date +"%Y-%m-%d")
    echo "## [$current_version] - $date" >> $CHANGELOG
    echo "- $message" >> $CHANGELOG
    echo "" >> $CHANGELOG
    echo "✅ Release $current_version recorded."
}

case "$1" in
    version)
        show_version
        ;;
    bump)
        bump_version "$2"
        ;;
    changelog)
        add_changelog "$2"
        ;;
    release)
        release "$2"
        ;;
    help|*)
        show_help
        ;;
esac
