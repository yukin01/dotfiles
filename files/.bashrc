function has() {
  type "$1" &>/dev/null
}

# for homebrew
if  [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# for direnv
if has "direnv"; then
  eval "$(direnv hook bash)"
fi

# Activate mise
if has "mise"; then
  eval "$(mise activate bash)"
fi

# Set common rc
if [ -d ~/.rc ]; then
  source ~/.rc/exports
  source ~/.rc/aliases
  source ~/.rc/functions
fi

# scripts for business
[ -f ~/scripts-for-business/files/.envrc ] && source ~/scripts-for-business/files/.envrc

# set vi keybind
set -o vi

# colorize
if [ $UID -eq 0 ]; then
    PS1="\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
else
    PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
fi

# fzf bash completion and key-bindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
