#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Install mise tools ====="
echo ""

sleep 0.5
if has "mise"; then
  set -x
  mise install
  { set +x; } 2>/dev/null
else
  echo_exit "Please install mise."
fi

echo ""
echo "✅ Mise tools are installed successfully."
echo ""

echo ""
echo "===== Apply mise bootstrap (casks & macOS defaults) ====="
echo ""

# pkg 型 cask のインストールや /etc/shells への登録で sudo のパスワードを求められることがある
set -x
mise trust "$HOME/dotfiles/mise.toml"
mise -C "$HOME/dotfiles" bootstrap packages apply --yes
mise -C "$HOME/dotfiles" bootstrap macos defaults apply --yes
mise -C "$HOME/dotfiles" bootstrap user apply --yes
{ set +x; } 2>/dev/null

echo ""
echo "✅ Mise bootstrap is applied successfully."
echo ""
