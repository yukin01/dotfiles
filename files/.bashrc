# for asdf
if [ -d $HOME/.asdf ]; then
  source $HOME/.asdf/asdf.sh
  source $HOME/.asdf/completions/asdf.bash
fi

# for direnv
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# Set common rc
if [ -d $HOME/.rc ]; then
  source $HOME/.rc/exports
  source $HOME/.rc/aliases
  source $HOME/.rc/functions
fi

# scripts for business
[ -f $HOME/scripts-for-business/files/.envrc ] && source $HOME/scripts-for-business/files/.envrc

# set vi keybind
set -o vi

# fzf bash completion and key-bindings

# colorize
if [ $UID -eq 0 ]; then
    PS1="\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
else
    PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
fi
