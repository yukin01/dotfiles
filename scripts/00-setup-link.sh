#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Make dotfiles symbolic link ====="
echo ""

DOTFILES_DIR="$HOME/dotfiles/files"
cd "$DOTFILES_DIR"
for f in .??*; do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".gitmodules" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -snfv "$DOTFILES_DIR/$f" "$HOME/$f"
done

echo ""
echo "🎉 Dotfiles are linked successfully."
echo ""
