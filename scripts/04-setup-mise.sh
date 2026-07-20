#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Install mise tools ====="
echo ""

sleep 0.5
# インストール済みでも呼び出し元シェルの PATH に ~/.local/bin が無いと
# has "mise" が誤って false になるため、判定より先に PATH を通す
export PATH="$HOME/.local/bin:$PATH"
if ! has "mise"; then
  echo "mise not found. Installing via https://mise.run ..."
  curl -fsSL https://mise.run | sh
fi

# mise は cwd から親方向に設定ファイルを探すため、~/dotfiles で実行すると
# mise install も ./mise.toml を読む。未 trust だとエラーになるので先に trust する
set -x
mise trust "$HOME/dotfiles/mise.toml"
mise install
{ set +x; } 2>/dev/null

echo ""
echo "✅ Mise tools are installed successfully."
echo ""

echo ""
echo "===== Apply mise bootstrap (casks & macOS defaults) ====="
echo ""

# pkg 型 cask のインストールや /etc/shells への登録で sudo のパスワードを求められることがある
set -x
mise -C "$HOME/dotfiles" bootstrap packages apply --yes
mise -C "$HOME/dotfiles" bootstrap macos defaults apply --yes
mise -C "$HOME/dotfiles" bootstrap user apply --yes
{ set +x; } 2>/dev/null

echo ""
echo "✅ Mise bootstrap is applied successfully."
echo ""
