#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.

echo "Starting Zinit installation check..."

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME/.git" ]; then
  echo "Zinit not found at $ZINIT_HOME. Cloning Zinit..."
  # Ensure the parent directory exists
  mkdir -p "$(dirname "$ZINIT_HOME")"
  # Clone Zinit
  if git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; then
    echo "Zinit cloned successfully to $ZINIT_HOME."
  else
    echo "Error: Failed to clone Zinit."
    exit 1
  fi
else
  echo "Zinit is already installed at $ZINIT_HOME."
  # Optional: You could add logic here to update Zinit if desired, e.g.,
  # echo "Updating Zinit..."
  # (cd "$ZINIT_HOME" && git pull)
fi

echo "Zinit installation check completed."
exit 0
