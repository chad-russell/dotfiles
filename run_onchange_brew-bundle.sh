#!/bin/sh

BREW_EXECUTABLE=""
BREW_CMD=""

# Attempt to find brew and set up its environment using shellenv
echo "Attempting to locate Homebrew and configure its environment..."
if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  BREW_EXECUTABLE="/home/linuxbrew/.linuxbrew/bin/brew"
  echo "Found Homebrew for Linux at $BREW_EXECUTABLE."
elif [ -x "/opt/homebrew/bin/brew" ]; then
  BREW_EXECUTABLE="/opt/homebrew/bin/brew" # Apple Silicon
  echo "Found Homebrew for macOS (Apple Silicon) at $BREW_EXECUTABLE."
elif [ -x "/usr/local/bin/brew" ]; then
  BREW_EXECUTABLE="/usr/local/bin/brew" # Intel Macs / older Linuxbrew
  echo "Found Homebrew (Intel Mac / older Linuxbrew) at $BREW_EXECUTABLE."
else
  echo "No Homebrew installation found at common locations."
fi

if [ -n "$BREW_EXECUTABLE" ]; then
  echo "Attempting to set up Homebrew environment using: eval \"\$($BREW_EXECUTABLE shellenv)\""
  eval "$($BREW_EXECUTABLE shellenv)"
  # Verify if eval was successful in adding brew to PATH
  if command -v brew >/dev/null 2>&1; then
    echo "'brew' command is now in PATH."
    BREW_CMD="brew"
  else
    echo "'brew' command is NOT in PATH after running shellenv. Will try using full path to executable: $BREW_EXECUTABLE"
    BREW_CMD="$BREW_EXECUTABLE" # Fallback to using the full path
  fi
else
  # If BREW_EXECUTABLE was never found, try one last time to see if it's in PATH for some other reason
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew installation not found at common paths, but 'brew' is in PATH."
    BREW_CMD="brew"
  else
    echo "Error: Homebrew executable not found at common locations and 'brew' is not in PATH."
    echo "Please ensure Homebrew is installed correctly. The 'run_once_before_install-homebrew.sh' script should handle this."
    exit 1
  fi
fi

# Final check if we have a usable brew command (either 'brew' or a full path)
if [ -z "$BREW_CMD" ] || ! command -v "$BREW_CMD" >/dev/null 2>&1; then
    echo "Critical Error: Unable to determine a usable 'brew' command. BREW_CMD was '$BREW_CMD'."
    exit 1
fi

echo "Using '$BREW_CMD' for brew commands."
echo "Attempting to run: $BREW_CMD bundle install --file $HOME/Brewfile --verbose"
echo "Checking if $HOME/Brewfile exists and is a symlink:"
ls -l "$HOME/Brewfile"

# Run brew bundle install
if ! "$BREW_CMD" bundle install --file "$HOME/Brewfile" --verbose; then
  echo "Error: '$BREW_CMD bundle install' command failed."
  exit 1
fi

echo "'$BREW_CMD bundle install' completed successfully."
