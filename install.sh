#!/usr/bin/env bash
set -eu

echo ""
echo "===== Clone dotfiles repository ====="
echo ""

INSTALL_DIR="$HOME/dotfiles"

type "git" > /dev/null 2>&1 || (echo "Please install git." 1>&2 && exit 1)

if [[ -d "${INSTALL_DIR}" ]]; then
  echo "Dotfiles repository already exists."
else
  set -x
  git clone --recursive https://github.com/yukin01/dotfiles.git "${INSTALL_DIR}"
  { set +x; } 2>/dev/null
fi

echo
echo "✅ Dotfiles are installed successfully."
echo

bash "${INSTALL_DIR}/scripts/00-setup-link.sh"
