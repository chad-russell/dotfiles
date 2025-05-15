#!/bin/sh

# Run brew bundle to install/update packages from Brewfile
# The --file argument points to the Brewfile in the chezmoi source directory
# which will be symlinked to the destination directory by chezmoi.
# brew bundle --file ~/.Brewfile # This is an alternative if symlinking is an issue or for testing.

brew bundle --file "{{ .chezmoi.sourceDir }}/Brewfile" --no-lock
