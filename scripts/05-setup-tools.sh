#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Install fzf settings ====="
echo ""

if has "brew" && has "fzf" ; then
  set -x
  "$(brew --prefix)"/opt/fzf/install --key-bindings --no-completion --no-update-rc
  { set +x; } 2>/dev/null

  echo ""
  echo "✅ FZF is configured successfully."
  echo ""
fi

echo ""
echo "===== Login to github cli ====="
echo ""

if has "gh"; then
  set -x
  gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key
  { set +x; } 2>/dev/null

  echo ""
  echo "✅ GitHub CLI is configured successfully."
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
  echo "✅ Yarn global packages are installed successfully."
  echo ""
fi

echo ""
echo "===== Change default shell ====="
echo ""

if cat /etc/shells | grep "$(brew --prefix)/bin/zsh" &>/dev/null; then
  echo ""
  echo "✅ Zsh is already registered in /etc/shells."
  echo ""
else
  set -x
  echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells
  { set +x; } 2>/dev/null

  echo ""
  echo "✅ Zsh is registered in /etc/shells."
  echo ""
fi

if [[ "$SHELL" == "$(brew --prefix)/bin/zsh" ]]; then
  echo ""
  echo "✅ Default shell is already zsh."
  echo ""
else
  set -x
  chsh -s "$(brew --prefix)/bin/zsh"
  { set +x; } 2>/dev/null

  echo ""
  echo "✅ Default shell is changed to zsh."
  echo ""
fi

echo ""
echo "🎉 MacOS setup has been successfully completed."
echo ""
