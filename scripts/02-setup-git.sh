#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Setup gitconfig ====="
echo ""

has "git" || echo_exit "Please install git."

[[ -f "$HOME/.gitconfig" ]] || touch "$HOME/.gitconfig"

default_git_name=$(git config --file "$HOME/.config/git/config" --get user.name || echo "")
default_git_email=$(git config --file "$HOME/.config/git/config" --get user.email || echo "")

git_name=$(git config --global --get user.name || echo "")
git_email=$(git config --global --get user.email || echo "")

echo "Current git user:"
echo ""
echo "    user.name=${git_name:=$default_git_name}"
echo "    user.email=${git_email:=$default_git_email}"
echo ""
echo "To overwrite name and email, update global config."
echo ""
echo "    git config --global user.name your_name"
echo "    git config --global user.email your_email"
echo ""

echo ""
echo "===== Set git remote repository ====="
echo ""

if [[ -d "$HOME/dotfiles" ]]; then
  cd "$HOME/dotfiles"
  set -x
  git remote set-url origin git@github.com:yukin01/dotfiles.git
  git remote -v
  git fetch
  { set +x; } 2>/dev/null
fi

echo ""
echo "Git is configured successfully."
echo ""
