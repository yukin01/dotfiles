#!/usr/bin/env bash
set -eu

CLAUDE_DIR="$HOME/dotfiles/files/.claude"
BASE="$CLAUDE_DIR/settings.base.json"
OUT="$CLAUDE_DIR/settings.json"

if [[ ! -f "$BASE" ]]; then
  echo "Error: $BASE not found" >&2
  exit 1
fi

if [[ -f "$OUT" ]]; then
  merged=$(jq -s '.[0] * .[1]' "$OUT" "$BASE")
  echo "$merged" > "$OUT"
  echo "Merged settings.base.json into settings.json"
else
  cp "$BASE" "$OUT"
  echo "Copied settings.base.json -> settings.json"
fi
