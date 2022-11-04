#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Install prezto ====="
echo ""

sleep 0.5
if [[ -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
  echo "already installed"
else
  set -x
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  { set +x; } 2>/dev/null

  echo ""
  echo "Prezto is installed successfully."
  echo ""
fi

echo ""
echo "===== Install fzf settings ====="
echo ""

if has "brew" && has "fzf" ; then
  set -x
  "$(brew --prefix)"/opt/fzf/install --key-bindings --no-completion --no-update-rc
  { set +x; } 2>/dev/null

  echo ""
  echo "FZF is configured successfully."
  echo ""
fi

echo ""
echo "===== Login to github cli ====="
echo ""

if has "gh"; then
  set -x
  gh auth login --hostname github.com --git-protocol ssh --web
  { set +x; } 2>/dev/null

  echo ""
  echo "GitHub CLI is configured successfully."
  echo ""
fi

echo ""
echo "===== Install yarn global packages ====="
echo ""

if has "yarn"; then
  set -x
  yarn global add
  { set +x; } 2>/dev/null

  echo ""
  echo "GitHub CLI is configured successfully."
  echo ""
fi

echo "Set up your macOS successfully."
