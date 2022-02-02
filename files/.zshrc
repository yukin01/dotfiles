#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Setup starship
if type starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG=$HOME/.starship.toml
  eval "$(starship init zsh)"
fi

# for asdf
if [ -d $HOME/.asdf ]; then
  source $HOME/.asdf/asdf.sh
  fpath=(${ASDF_DIR}/completions $fpath)
  autoload -Uz compinit && compinit
fi

# for direnv
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# for tfswitch hook
load-tfswitch() {
  local tfswitchrc_path="providers.tf"

  if [ -f "$tfswitchrc_path" ]; then
    tfswitch
  fi
}
add-zsh-hook chpwd load-tfswitch
load-tfswitch

# for gcloud on macos
if type brew > /dev/null 2>&1 && type gcloud > /dev/null 2>&1; then
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# for kubectl completion
# type kubectl &>/dev/null && source <(kubectl completion zsh)

# for awscli completion
# if type aws_completer &>/dev/null; then
#   complete -C aws_completer aws
#   complete -C aws_completer aws-vault
# fi

# for aws-vault completion
if type aws-vault >/dev/null 2>&1; then
  eval "$(aws-vault --completion-script-zsh)"
fi

# for additional zsh completions
# fpath=($HOME/dotfiles/completions/zsh $fpath)
# autoload -Uz compinit && compinit

# for fzf zsh completion and key-bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# generate fzf configuration file
if [ ! -f ~/.fzf.zsh ] && type brew > /dev/null 2>&1; then
  $(brew --prefix)/opt/fzf/install \
    --key-bindings --no-completion --no-update-rc
fi

# Set common rc
if [ -d $HOME/.rc ]; then
  source $HOME/.rc/exports
  source $HOME/.rc/aliases
  source $HOME/.rc/functions
fi

# scripts for business
[ -f $HOME/scripts-for-business/files/.envrc ] && source $HOME/scripts-for-business/files/.envrc

# Set vi keybind
bindkey -v

# Profiling
if (which zprof > /dev/null 2>&1) ;then
  zprof | less
fi
