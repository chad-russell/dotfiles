#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.

echo "Starting installation of mise and zoxide..."

# --- Prerequisite Check ---
# Ensure curl and git are available.
# In a devcontainer, these are often pre-installed or easy to add to the base image/features.
# For wider compatibility, you might add explicit checks or installation commands here.
# For example:
# if ! command -v curl >/dev/null; then echo "curl not found. Please install curl."; exit 1; fi
# if ! command -v git >/dev/null; then echo "git not found. Please install git."; exit 1; fi

# --- Install mise ---
MISE_INSTALL_PATH="$HOME/.local/bin/mise"
if [ ! -x "$MISE_INSTALL_PATH" ]; then
  echo "'mise' not found at $MISE_INSTALL_PATH. Installing mise..."
  # Create the target directory if it doesn't exist
  mkdir -p "$HOME/.local/bin"
  # Install mise using the official script
  curl -fsSL https://mise.run | sh
  # The script should install it to ~/.local/bin/mise
  if [ ! -x "$MISE_INSTALL_PATH" ]; then
    echo "Error: mise installation failed or it was not installed to $MISE_INSTALL_PATH."
    exit 1
  fi
  echo "mise installed successfully to $MISE_INSTALL_PATH."
else
  echo "mise is already installed at $MISE_INSTALL_PATH."
fi

# Ensure $HOME/.local/bin is in PATH for this script's execution
export PATH="$HOME/.local/bin:$PATH"

# Verify mise is now callable
if ! command -v mise >/dev/null; then
  echo "Error: 'mise' command not found in PATH even after attempted installation and PATH modification."
  exit 1
fi
echo "mise command is available in PATH."
mise --version

# --- Use mise to install zoxide ---
echo "Using mise to install/activate zoxide@latest globally..."
if mise use --global zoxide@latest; then
  echo "mise successfully configured zoxide."
else
  echo "Error: 'mise use --global zoxide@latest' command failed."
  exit 1
fi

echo "mise and zoxide installation/configuration script completed."
exit 0
