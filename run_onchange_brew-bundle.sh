#!/bin/sh

# Run brew bundle install to install/update packages from Brewfile
# The --file argument points to the Brewfile in the chezmoi source directory.
echo "Executing: brew bundle install --file {{ .chezmoi.sourceDir }}/Brewfile"
brew bundle install --file "{{ .chezmoi.sourceDir }}/Brewfile"
