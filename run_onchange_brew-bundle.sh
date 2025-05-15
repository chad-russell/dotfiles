#!/bin/sh

echo "Attempting to run: brew bundle install --file $HOME/Brewfile --verbose"
echo "Checking if $HOME/Brewfile exists and is a symlink:"
ls -l "$HOME/Brewfile"

# Run brew bundle install, pointing to the Brewfile symlinked by chezmoi in the home directory.
brew bundle install --file "$HOME/Brewfile" --verbose
