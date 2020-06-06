#!/bin/bash
set -eu

echo
echo ===== make Dotfiles symbolic link =====
echo

DOTFILES_DIR="$HOME/dotfiles/files"

cd $DOTFILES_DIR || (echo Please clone dotfiles && exit 1)

for f in .??*; do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".gitmodules" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -snfv $DOTFILES_DIR/$f $HOME/$f
done

echo
echo Dotfiles installation is completed successfully!
echo
