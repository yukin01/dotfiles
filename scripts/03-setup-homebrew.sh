#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Install homebrew ====="
echo ""

BREW_PATH="$HOME/dotfiles/Brewfile"

sleep 0.5
if has "brew"; then
    echo "Already installed."
elif has "git" && has "curl"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo_exit "Please install git and curl."
fi
brew doctor

echo ""
echo "===== Execute 'brew install' ====="
echo ""

sleep 0.5
# virtualbox で躓くことがあるので先にインストールしておく
# if type virtualbox > /dev/null 2>&1; then
#     echo "Virtualbox is already installed."
# else
#     brew install --cask virtualbox
# fi
brew bundle --file="${BREW_PATH}"

echo ""
echo "Homebrew and packages are installed successfully."
echo ""
