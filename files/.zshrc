function has() {
  type "$1" &>/dev/null
}

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Setup starship
if has "starship"; then
  export STARSHIP_CONFIG=$HOME/.starship.toml
  eval "$(starship init zsh)"
fi

# For asdf
if [[ -d "$HOME/.asdf" ]]; then
  source "$HOME/.asdf/asdf.sh"
  fpath=(${ASDF_DIR}/completions $fpath)
  autoload -Uz compinit && compinit
fi

# For direnv
if has "direnv"; then
  eval "$(direnv hook zsh)"
fi

# For tfswitch hook
load-tfswitch() {
  local tfswitchrc_path="providers.tf"

  if [[ -f "${tfswitchrc_path}" ]]; then
    tfswitch
  fi
}
add-zsh-hook chpwd load-tfswitch
load-tfswitch

# For gcloud completion on macos
if has "brew" && has "gcloud" 2>&1; then
  # source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# for kubectl completion
# NOTE: this has been moved to `.rc/functions`.

# for awscli completion
# NOTE: https://github.com/Homebrew/homebrew-core/blob/6798763743df1ad3fe256aa27b39807ab690437a/Formula/awscli.rb#L117-L125

# for aws-vault completion
if has "aws-vault"; then
  eval "$(aws-vault --completion-script-zsh)"
fi

# for additional zsh completions
# fpath=($HOME/dotfiles/completions/zsh $fpath)
# autoload -Uz compinit && compinit

# Set common rc
if [[ -d ~/.rc ]]; then
  source ~/.rc/exports
  source ~/.rc/aliases
  source ~/.rc/functions
fi

# scripts for business
[[ -f ~/scripts-for-business/files/.envrc ]] && source ~/scripts-for-business/files/.envrc

# Set vi keybind
bindkey -v

# for fzf key-bindings
# this should be sourced after `bindkey -v`
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Profiling
if has "zprof"; then
  zprof | less
fi
