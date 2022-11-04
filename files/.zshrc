# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
function has() {
  type "$1" &>/dev/null
}

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Setup starship
if has "starship"; then
  eval "$(starship init zsh)"
fi

# For my completion (before compinit in asdf)
if [[ -d "$HOME/dotfiles" ]]; then
  fpath=($HOME/dotfiles/completions/zsh $fpath)
  autoload -Uz compinit && compinit
fi

# For asdf
if [[ -d "$HOME/.asdf" ]]; then
  source "$HOME/.asdf/asdf.sh"
  # fpath=(${ASDF_DIR}/completions $fpath)
  # autoload -Uz compinit && compinit
fi

# For direnv
# if has "direnv"; then
#   eval "$(direnv hook zsh)"
# fi

# For asdf-direnv
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc" ]]; then
  source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
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
if [[ -d "/usr/local/Caskroom/google-cloud-sdk" ]]; then
  # source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  # source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# Set common rc
if [[ -d ~/.rc ]]; then
  source ~/.rc/exports
  source ~/.rc/aliases
  source ~/.rc/functions
fi

# Scripts for business
[[ -f ~/scripts-for-business/files/.envrc ]] && source ~/scripts-for-business/files/.envrc

# Set vi keybind
bindkey -v

# For fzf key-bindings
# this should be sourced after `bindkey -v`
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
