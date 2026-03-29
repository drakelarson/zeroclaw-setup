#!/bin/bash
#
# Install ZeroClaw binary from GitHub releases
#
# Usage: ./install-zeroclaw.sh [--version VERSION]
#
# Options:
#   --version    Specific version to install (default: latest)
#   --help       Show this help
#

set -e

RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
NC='\\033[0m'

VERSION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --help|-h)
            head -20 "$0"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo -e "${YELLOW}Installing ZeroClaw binary...${NC}"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    armv7l) ARCH="armv7" ;;
    *)
        echo -e "${RED}Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

TARGET="${ARCH}-unknown-${OS}-gnu"

# Get latest version if not specified
if [[ -z "$VERSION" ]]; then
    echo "Fetching latest version..."
    VERSION=$(curl -s https://api.github.com/repos/zeroclaw-labs/zeroclaw/releases/latest | jq -r '.tag_name')
    if [[ -z "$VERSION" ]] || [[ "$VERSION" == "null" ]]; then
        echo -e "${RED}Failed to fetch latest version${NC}"
        exit 1
    fi
fi

echo "Installing ZeroClaw $VERSION for $TARGET"

# Download URL
TARBALL="zeroclaw-${TARGET}.tar.gz"
URL="https://github.com/zeroclaw-labs/zeroclaw/releases/download/${VERSION}/${TARBALL}"

# Create temp directory
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# Download and extract
echo "Downloading from $URL..."
if ! curl -sL "$URL" -o "$TMPDIR/$TARBALL"; then
    echo -e "${RED}Download failed${NC}"
    exit 1
fi

echo "Extracting..."
tar -xzf "$TMPDIR/$TARBALL" -C "$TMPDIR"

# Find the binary
BINARY=$(find "$TMPDIR" -name "zeroclaw" -type f | head -1)
if [[ -z "$BINARY" ]]; then
    echo -e "${RED}Binary not found in archive${NC}"
    exit 1
fi

# Install
echo "Installing to /usr/local/bin/zeroclaw..."
chmod +x "$BINARY"
mv "$BINARY" /usr/local/bin/zeroclaw

# Verify
VERSION_INSTALLED=$(/usr/local/bin/zeroclaw --version 2>&1 | head -1 || echo "installed")
echo -e "${GREEN}✅ ZeroClaw installed: $VERSION_INSTALLED${NC}"

# Create workspace directory
mkdir -p /root/.zeroclaw/workspace

echo "Workspace: /root/.zeroclaw/workspace"