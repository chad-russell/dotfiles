#!/bin/sh

# Script to install Oh My Posh if not already present

TARGET_DIR="/usr/local/bin"
TARGET_FILE="$TARGET_DIR/oh-my-posh"

# Check if oh-my-posh is already installed
if command -v oh-my-posh >/dev/null 2>&1 && [ -x "$TARGET_FILE" ]; then
  echo "oh-my-posh is already installed at $TARGET_FILE."
  exit 0
fi

echo "oh-my-posh not found or not executable. Installing..."

# Determine architecture
ARCH=$(uname -m)
OMP_ARCH=""
case "$ARCH" in
  x86_64)  OMP_ARCH="amd64" ;;
  aarch64) OMP_ARCH="arm64" ;;
  arm64)   OMP_ARCH="arm64" ;;
  *)
    echo "Error: Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

echo "Detected architecture: $ARCH, using OMP_ARCH: $OMP_ARCH"

# Fetch the latest release URL for the determined architecture
# This is a bit more complex to do robustly in pure sh without jq,
# so we'll fetch the latest release tag and construct the URL.
# Oh My Posh often uses 'posh-linux-<arch>' or just 'posh-<arch>' for its assets.
# For simplicity, we'll hardcode a recent known working pattern if a dynamic fetch proves too complex here.

# Simpler: use the direct install command from their docs if available and suitable.
# From https://ohmyposh.dev/docs/installation/linux
echo "Downloading oh-my-posh for $OMP_ARCH..."
if curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$TARGET_DIR"; then
  echo "oh-my-posh installed successfully to $TARGET_FILE."
  # The install.sh script should handle making it executable.
  # Just in case:
  if [ ! -x "$TARGET_FILE" ]; then
    echo "Making $TARGET_FILE executable..."
    sudo -n chmod +x "$TARGET_FILE"
  fi
else
  echo "Error: oh-my-posh installation failed."
  exit 1
fi

exit 0
