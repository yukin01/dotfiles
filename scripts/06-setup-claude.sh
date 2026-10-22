#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

CLAUDE_DIR="$HOME/dotfiles/files/.claude"
BASE="$CLAUDE_DIR/settings.base.json"
OUT="$CLAUDE_DIR/settings.json"

if [[ ! -f "$BASE" ]]; then
  echo "Error: $BASE not found" >&2
  exit 1
fi

if [[ -f "$OUT" ]]; then
  merged=$(yq -o json -I 2 ea '. as $item ireduce({}; . *d $item)' "$OUT" "$BASE")
  echo "$merged" > "$OUT"
  echo "Deep-merged settings.base.json into settings.json"
else
  cp "$BASE" "$OUT"
  echo "Copied settings.base.json -> settings.json"
fi

# herdr の Claude 連携 (セッション再開用の hook) は herdr が生成・更新するため dotfiles では管理せず、ここで入れる。
# herdr は mise 管理なので、mise activate 前のシェルからでも見つかるよう shim を通す
export PATH="$HOME/.local/share/mise/shims:$PATH"
if has "herdr"; then
  herdr integration install claude
fi
