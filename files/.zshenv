# Profiling
if [[ -n "${ENABLE_PROFILING}" ]]; then
  zmodload zsh/zprof && zprof
fi
