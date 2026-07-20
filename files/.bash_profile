# Hybrid mise setup: shims for non-interactive (login) contexts.
# Interactive shells re-activate in .bashrc, which supersedes these shims.
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate bash --shims)"
fi

# Get the aliases and functions
[ -f ~/.bashrc ] && . ~/.bashrc
