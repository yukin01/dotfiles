# Profiling
if [[ -n "${ENABLE_ZSH_PROFILING}" ]]; then
  zmodload zsh/zprof && zprof
fi
