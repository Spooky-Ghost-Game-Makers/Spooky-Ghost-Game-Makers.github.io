#!/bin/bash
#
# vendor_pyscript.sh - Download and vendor PyScript distribution files
#
# This script downloads PyScript from npm and extracts the dist/ folder
# into assets/pyscript/ for local hosting without CDN dependencies.
#
# Usage: ./vendor_pyscript.sh [version]
#   version: PyScript version to download (default: 0.4.21)
#
# The script is idempotent - running it multiple times will overwrite
# existing files with fresh downloads.
#

set -e

# Default PyScript version
PYSCRIPT_VERSION="${1:-0.4.21}"

# Target directory (relative to script location)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$SCRIPT_DIR/assets/pyscript"

# Temporary directory for extraction
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

echo "=== PyScript Vendor Script ==="
echo "Version: $PYSCRIPT_VERSION"
echo "Target:  $TARGET_DIR"
echo ""

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

# Download PyScript package from npm
echo "Downloading @pyscript/core@$PYSCRIPT_VERSION..."
cd "$TMP_DIR"

npm pack "@pyscript/core@$PYSCRIPT_VERSION" --silent 2>/dev/null || {
    echo "ERROR: Failed to download @pyscript/core@$PYSCRIPT_VERSION from npm"
    echo "Please check if the version exists at https://www.npmjs.com/package/@pyscript/core"
    exit 1
}

TARBALL=$(ls pyscript-core-*.tgz 2>/dev/null || ls *.tgz 2>/dev/null | head -1)
if [ -z "$TARBALL" ]; then
    echo "ERROR: No tarball found after npm pack"
    exit 1
fi

echo "Extracting $TARBALL..."
tar -xzf "$TARBALL"

# Check for package/dist directory
if [ ! -d "package/dist" ]; then
    echo "ERROR: dist/ directory not found in package"
    echo "Package contents:"
    ls -la package/
    exit 1
fi

# Copy dist/ contents to target directory
echo "Copying dist/ files to $TARGET_DIR..."
cp -r package/dist/* "$TARGET_DIR/"

# Verify critical files exist
echo ""
echo "Verifying installation..."
CRITICAL_FILES=("core.js" "core.css")
ALL_OK=true

for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$TARGET_DIR/$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (MISSING)"
        ALL_OK=false
    fi
done

if [ "$ALL_OK" = true ]; then
    echo ""
    echo "=== Success! ==="
    echo "PyScript $PYSCRIPT_VERSION has been vendored to $TARGET_DIR"
    echo ""
    echo "Files installed:"
    ls -lh "$TARGET_DIR/"*.js "$TARGET_DIR/"*.css 2>/dev/null | head -20
    echo ""
    echo "To use in HTML:"
    echo '  <link rel="stylesheet" href="./assets/pyscript/core.css" />'
    echo '  <script type="module" src="./assets/pyscript/core.js"></script>'
else
    echo ""
    echo "=== WARNING: Some files may be missing ==="
    echo "The installation completed but some expected files were not found."
    echo "Please check the target directory: $TARGET_DIR"
    exit 1
fi
