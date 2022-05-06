#!/bin/bash
set -eu

OS=""
if [[ "$(uname)" == "Darwin" ]]; then
  OS="Mac"
elif [[ "$(uname)" == "Linux" ]]; then
  OS="Linux"
else
  echo "Unsupported OS" 1>&2
  exit 1
fi

echo "---------------------------"
echo "Installation type is ${OS} "
echo "---------------------------"

echo ""
echo "===== Make SSH directory ====="
echo ""

if [[ -d ~/.ssh ]]; then
  echo "SSH directory already exists."
else
  set -x
  install -m 700 -d ~/.ssh
  { set +x; } 2>/dev/null
fi

if [[ ! -d ~/.ssh/conf.d ]]; then
  set -x
  mkdir ~/.ssh/conf.d
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

if [[ -f ~/.ssh/config ]]; then
  echo "SSH config file already exists."
  echo "If you need common settings, add manually."
else
  set -x
  echo "${SSH_CONFIG}" > ~/.ssh/config
  { set +x; } 2>/dev/null

  if [[ "${OS}" == "Mac" ]]; then
    set -x
    echo "  UseKeychain yes" >> ~/.ssh/config
    { set +x; } 2>/dev/null
  fi
fi

echo ""
echo "===== Generate SSH key ====="
echo ""

if [[ -f ~/.ssh/id_ed25519 ]] && [[ -f ~/.ssh/id_ed25519.pub ]]; then
  echo "SSH key pair already exists."
else
  read -r -p "Enter your email address: " email
  echo ""

  set -x
  # ssh-keygen -t rsa -b 4096 -C "${email}"
  ssh-keygen -t ed25519 -C "${email}"
  { set +x; } 2>/dev/null

  echo ""
  echo "Your public key is..."
  echo ""
  cat ~/.ssh/id_ed25519.pub
  [[ ${OS} == "Mac" ]] && pbcopy < ~/.ssh/id_ed25519.pub
  echo ""
  read -r -p "After registering public key, press the enter key: "
fi

echo ""
echo "SSH is configured successfully."
echo ""
