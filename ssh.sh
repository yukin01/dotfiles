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

if [ -d ~/.ssh ]; then
  echo "SSH directory already exists."
else
  set -x
  install -m 700 -d ~/.ssh
  set +x
fi
# [ ! -d ~/.ssh ] && install -m 700 -d ~/.ssh

if [ ! -d ~/.ssh/conf.d ]; then
  set -x
  mkdir ~/.ssh/conf.d
  set +x
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

if [ -f ~/.ssh/config ]; then
  echo "SSH config file already exists."
  echo "If you need common settings, add manually."
else
  set -x
  echo "${SSH_CONFIG}" > ~/.ssh/config
  [ $OS == "Mac" ] && echo "  UseKeychain yes" >> ~/.ssh/config
  set +x
fi

echo ""
echo "===== Generate SSH key ====="
echo ""

if [ -f ~/.ssh/id_rsa ] && [ -f ~/.ssh/id_rsa.pub ]; then
  echo "SSH key pair already exists."
else
  read -r -p "Enter your email address: " email
  set -x
  ssh-keygen -t rsa -b 4096 -C "${email}"
  set +x
  echo ""
  echo "Your public key is..."
  echo ""
  cat ~/.ssh/id_rsa.pub
  echo
  read -r -p "After registering public key, press the enter key: "
fi

echo ""
echo "===== Set git remote repository ====="
echo ""

type git > /dev/null 2>&1 || (echo "Please install git" && exit 1)

git_name=$(git config --global --get user.name || echo "")
git_email=$(git config --global --get user.email || echo "")

if [ -z "${git_name}" ]; then
  default_git_name="yukin01"
  read -r -p "Enter your name (${default_git_name}): " git_name
  git config --global user.name "${git_name:=$default_git_name}"
fi
echo "Your git user name is ${git_name}"
echo ""

if [ -z "${git_email}" ]; then
  default_git_email="38382781+yukin01@users.noreply.github.com"
  read -r -p "Enter your email address (${default_git_email}): " git_email
  git config --global user.email "${git_email:=$default_git_email}"
fi
echo "Your git user email is ${git_email}"
echo ""

if [ -d ~/dotfiles ]; then
  cd ~/dotfiles
  set -x
  git remote set-url origin git@github.com:yukin01/dotfiles.git
  git remote -v
  git fetch
  set +x
fi

echo ""
echo "Git with ssh is configured successfully."
echo ""
