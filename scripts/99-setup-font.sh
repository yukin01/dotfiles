#!/usr/bin/env bash
set -eu

# powerline fonts
echo ""
echo "===== Install powerline fonts ====="
echo ""
sleep 0.5
if find "$HOME/Library/Fonts" -name "Ubuntu*" >/dev/null 2>&1; then
  echo "already installed"
else
  "$HOME/dotfiles/fonts/install.sh"
  echo ""
  echo "Powerline fonts are installed successfully."
  echo ""
fi
