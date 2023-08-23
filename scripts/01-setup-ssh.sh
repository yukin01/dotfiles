#!/bin/bash
set -eu

# shellcheck source=./lib/utils.sh
source "$(dirname "$0")/../lib/utils.sh"

echo ""
echo "===== Make SSH directory ====="
echo ""

if [[ -d "$HOME/.ssh" ]]; then
  echo "SSH directory already exists."
else
  set -x
  install -m 700 -d "$HOME/.ssh"
  { set +x; } 2>/dev/null
fi

if [[ ! -d "$HOME/.ssh/conf.d" ]]; then
  set -x
  mkdir "$HOME/.ssh/conf.d"
  { set +x; } 2>/dev/null
fi

echo ""
echo "===== Make SSH config file ====="
echo ""

SSH_CONFIG=$(cat <<-EOS
Include conf.d/*

Host *
  ServerAliveInterval 1200
  ServerAliveCountMax 12
  TCPKeepAlive yes
  Compression yes
  GSSAPIAuthentication no
  UseRoaming no
  AddKeysToAgent yes
EOS
)

if [[ -f "$HOME/.ssh/config" ]]; then
  echo "SSH config file already exists."
  echo "If you need common settings, add manually."
else
  set -x
  echo "${SSH_CONFIG}" > "$HOME/.ssh/config"
  { set +x; } 2>/dev/null

  if [[ "$(uname)" == "Darwin" ]]; then
    set -x
    echo "  UseKeychain yes" >> ~/.ssh/config
    { set +x; } 2>/dev/null
  fi
fi

echo ""
echo "===== Generate SSH key ====="
echo ""

if [[ -f "$HOME/.ssh/id_ed25519" ]] && [[ -f "$HOME/.ssh/id_ed25519.pub" ]]; then
  echo "SSH key pair already exists. Skip generating key pair and copy public key."
  [[ "$(uname)" == "Darwin" ]] && pbcopy < "$HOME/.ssh/id_ed25519.pub"
else
  read -r -p "Enter your email address: " email
  echo ""

  set -x
  ssh-keygen -t ed25519 -C "${email}"
  { set +x; } 2>/dev/null

  echo ""
  echo "Your public key is..."
  echo ""
  cat "$HOME/.ssh/id_ed25519.pub"
  [[ "$(uname)" == "Darwin" ]] && pbcopy < "$HOME/.ssh/id_ed25519.pub"
  echo ""
  read -r -p "After registering authentication key and signing key, press the enter key: "
fi

echo ""
echo "SSH is configured successfully."
echo ""
