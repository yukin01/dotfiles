#!/bin/bash
set -e

OS=""
if [[ "$(uname)" == "Darwin" ]]; then
  OS="Mac"
elif [[ "$(uname)" == "Linux" ]]; then
  OS="Linux"
else
  echo "Unsupported OS" 1>&2
  exit 1
fi

echo "---------------------------"
echo "Installation type is ${OS}   "
echo "---------------------------"

echo ""
echo "===== Clone dotfiles repository ====="
echo ""

type git > /dev/null 2>&1 || (echo "Please install git." && exit 1)
if [ -d "$HOME/dotfiles" ]; then
  echo "Dotfiles repository already exists."
else
  set -x
  git clone --recursive https://github.com/yukin01/dotfiles.git "$HOME/dotfiles"
  set +x
fi

echo ""
echo "===== Make dotfiles symbolic link ====="
echo ""

if [[ "${OS}" == "Mac" ]] || [[ "$1" == "--force" ]]; then
  DOTFILES_DIR="$HOME/dotfiles/files"
  cd "${DOTFILES_DIR}"
  for f in .??*; do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".gitmodules" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -snfv "${DOTFILES_DIR}/$f" "$HOME/$f"
  done
else
  echo "Do nothing."
fi

echo
echo "Dotfiles is installed successfully."
echo
