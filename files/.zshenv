# Profiling
if [[ -n "${ENABLE_ZSH_PROFILING}" ]]; then
  zmodload zsh/zprof && zprof
fi

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
