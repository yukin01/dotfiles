#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Login to github cli ====="
echo ""

# gh は mise 管理のため、mise activate 前のシェルから実行されても shim が通るようにする
export PATH="$HOME/.local/share/mise/shims:$PATH"
has "gh" || echo_exit "gh not found. Run 04-setup-mise.sh first."

# ここでは認証だけを行う。鍵の登録に必要な scope の取得・降格は
# 後段の "Upload SSH keys" セクションが状態を見て行う
if gh auth status --hostname github.com &>/dev/null; then
  echo "GitHub CLI is already logged in."
else
  set -x
  gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key
  { set +x; } 2>/dev/null
fi

PUB_KEY="$HOME/.ssh/id_ed25519.pub"
[[ -f "$PUB_KEY" ]] || echo_exit "$PUB_KEY not found. Run 01-setup-ssh.sh first."

echo ""
echo "===== Register github.com host keys ====="
echo ""

# 初回 SSH 接続時の TOFU (fingerprint の手動確認) を避けるため、
# TLS で保護された公式 API からホスト鍵を取得して known_hosts に登録する
if grep -qs "^github.com " "$HOME/.ssh/known_hosts"; then
  echo "github.com host keys already registered."
else
  gh api meta --jq '.ssh_keys[] | "github.com \(.)"' >> "$HOME/.ssh/known_hosts"
  echo "Added github.com host keys to known_hosts."
fi

echo ""
echo "===== Upload SSH keys to GitHub ====="
echo ""

key_body=$(awk '{print $2}' "$PUB_KEY")
key_title="$(whoami)@$(hostname)"

# アクティブアカウントのトークン scope 一覧を返す
function current_scopes() {
  gh auth status --hostname github.com --json hosts \
    --jq '.hosts["github.com"][] | select(.active) | .scopes'
}

# 鍵が指定タイプ (authentication | signing) で GitHub に登録済みかを確認する
# (一覧取得には read:public_key / read:ssh_signing_key scope が必要)
function key_registered() {
  gh ssh-key list 2>/dev/null | grep -F "$key_body" | grep -qw "$1"
}

# 鍵の登録に必要な admin scope が無ければ取得する (冪等)
function ensure_admin_scopes() {
  local scopes
  scopes=$(current_scopes)
  if [[ "$scopes" != *"admin:public_key"* || "$scopes" != *"admin:ssh_signing_key"* ]]; then
    set -x
    gh auth refresh --hostname github.com --scopes admin:public_key,admin:ssh_signing_key
    { set +x; } 2>/dev/null
  fi
}

# Step 1: read scope すら無いと登録済みかどうかを確認できないため、先に admin を取得する
# (通常の再実行時は降格済みの read scope が残っているので、ここは素通りする)
scopes=$(current_scopes)
if [[ "$scopes" != *"public_key"* || "$scopes" != *"ssh_signing_key"* ]]; then
  ensure_admin_scopes
fi

# Step 2: 各鍵の登録状態を確認し、未登録のものだけ登録する
if key_registered "authentication"; then
  echo "Authentication key is already registered."
else
  ensure_admin_scopes
  set -x
  gh ssh-key add "$PUB_KEY" --title "$key_title"
  { set +x; } 2>/dev/null
fi

if key_registered "signing"; then
  echo "Signing key is already registered."
else
  ensure_admin_scopes
  set -x
  gh ssh-key add "$PUB_KEY" --type signing --title "$key_title"
  { set +x; } 2>/dev/null
fi

# Step 3: admin scope が残っていれば、再実行時のチェックに必要な read scope へ降格する
scopes=$(current_scopes)
if [[ "$scopes" == *"admin:public_key"* || "$scopes" == *"admin:ssh_signing_key"* ]]; then
  set -x
  gh auth refresh --hostname github.com \
    --remove-scopes admin:public_key,admin:ssh_signing_key \
    --scopes read:public_key,read:ssh_signing_key
  { set +x; } 2>/dev/null
fi

echo ""
echo "===== Switch dotfiles remote to SSH ====="
echo ""

if [[ -d "$HOME/dotfiles/.git" ]]; then
  set -x
  git -C "$HOME/dotfiles" remote set-url origin git@github.com:yukin01/dotfiles.git
  git -C "$HOME/dotfiles" remote -v
  git -C "$HOME/dotfiles" fetch
  { set +x; } 2>/dev/null
fi

echo ""
echo "✅ GitHub CLI is configured successfully."
echo ""

echo ""
echo "🎉 MacOS setup has been successfully completed."
echo ""
