# for homebrew
if  [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# for asdf
if [ -d ~/.asdf ]; then
  source ~/.asdf/asdf.sh
  source ~/.asdf/completions/asdf.bash
fi

# for direnv
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook bash)"
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
