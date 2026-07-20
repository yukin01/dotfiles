#!/usr/bin/env bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

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
echo "🎉 MacOS setup has been successfully completed."
echo ""
