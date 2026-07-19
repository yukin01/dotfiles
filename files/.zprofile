# Hybrid mise setup: shims for non-interactive (login) contexts.
# Interactive shells re-activate in .zshrc, which supersedes these shims.
# mise is called by full path because brew shellenv has not run yet at this point.
if [[ -x /opt/homebrew/bin/mise ]]; then
  eval "$(/opt/homebrew/bin/mise activate zsh --shims)"
fi
