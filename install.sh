#!/bin/bash
# Attach daemon installer
# Usage: curl -fsSL https://raw.githubusercontent.com/Harris-A-Khan/homebrew-attach/main/install.sh | bash

set -e

REPO="Harris-A-Khan/homebrew-attach"
INSTALL_DIR="${ATTACHD_PREFIX:-/usr/local}/bin"
BINARY_NAME="attachd"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64)
        ARCH="amd64"
        ;;
    arm64|aarch64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH" >&2
        exit 1
        ;;
esac

case "$OS" in
    darwin|linux)
        ;;
    *)
        echo "Unsupported OS: $OS" >&2
        exit 1
        ;;
esac

ASSET_NAME="attachd-${OS}-${ARCH}"

echo "Installing attachd for ${OS}/${ARCH}..."

# Resolve latest release asset URL.
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep "browser_download_url.*${ASSET_NAME}\"" \
  | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find release asset ${ASSET_NAME}" >&2
    echo "Check https://github.com/${REPO}/releases" >&2
    exit 1
fi

# Download.
TMP_FILE=$(mktemp)
echo "Downloading from ${DOWNLOAD_URL}..."
curl -fsSL -o "$TMP_FILE" "$DOWNLOAD_URL"
chmod +x "$TMP_FILE"

# Install attachd.
mkdir -p "$INSTALL_DIR"
if [ -w "$INSTALL_DIR" ]; then
    mv "$TMP_FILE" "${INSTALL_DIR}/${BINARY_NAME}"
else
    echo "Installing to ${INSTALL_DIR} (requires sudo)..."
    sudo mv "$TMP_FILE" "${INSTALL_DIR}/${BINARY_NAME}"
fi

# Drop the `attach` shim alongside it.
SHIM_CONTENT='#!/usr/bin/env bash
exec attachd wrap "$@"'
if [ -w "$INSTALL_DIR" ]; then
    printf "%s" "$SHIM_CONTENT" > "${INSTALL_DIR}/attach"
    chmod +x "${INSTALL_DIR}/attach"
else
    echo "$SHIM_CONTENT" | sudo tee "${INSTALL_DIR}/attach" >/dev/null
    sudo chmod +x "${INSTALL_DIR}/attach"
fi

echo
echo "attachd installed successfully!"
echo
"${INSTALL_DIR}/${BINARY_NAME}" version
echo
echo "Next steps:"
echo "  attachd status               # confirm Tailscale detection"
echo "  attachd pair                 # print pairing QR for the iOS app"
echo "  attach claude                # run a wrapper from inside tmux"
