#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Install asdf ====="
echo ""

sleep 0.5
if [[ -d "$HOME/.asdf" ]]; then
  echo "Already installed."
else
  set -x
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.10.0
  { set +x; } 2>/dev/null
fi

# shellcheck source=/dev/null
has "asdf" || source "$HOME/.asdf/asdf.sh"

echo ""
echo "===== Install asdf plugins ====="
echo ""

sleep 0.5
set -x
"$HOME/dotfiles/bin/asdf-plugin-install"
asdf install
{ set +x; } 2>/dev/null

echo ""
echo "===== Setup asdf direnv ====="
echo ""

sleep 0.5
set -x
asdf direnv setup --shell zsh --version latest
{ set +x; } 2>/dev/null
