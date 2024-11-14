#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Install mise tools ====="
echo ""

sleep 0.5
if has "mise"; then
  set -x
  mise install
  { set +x; } 2>/dev/null
else
  echo_exit "Please install mise."
fi

echo ""
echo "✅ Mise tools are installed successfully."
echo ""
