# Hybrid mise setup: shims for non-interactive (login) contexts.
# Interactive shells re-activate in .zshrc, which supersedes these shims.
if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh --shims)"
fi
