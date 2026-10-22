# Hybrid mise setup: shims for non-interactive (login) contexts.
# Interactive shells re-activate in .zshrc, which supersedes these shims.
if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh --shims)"
fi

# Point OpenSSL/LibreSSL clients (/usr/bin/curl, ruby, ...) and git's libcurl at the
# Homebrew CA bundle: macOS's /etc/ssl/cert.pem lags behind distrust events (e.g. eMudhra 2026-10).
# Guarded so a fresh machine without ca-certificates keeps working (git over HTTPS is used during setup).
if [[ -f /opt/homebrew/etc/ca-certificates/cert.pem ]]; then
  export SSL_CERT_FILE=/opt/homebrew/etc/ca-certificates/cert.pem
  export GIT_SSL_CAINFO="$SSL_CERT_FILE"
fi
