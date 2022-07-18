#!/usr/bin/env bash
set -eu

function has() {
  if [ "$#" -eq 2 ]; then
    type "$1" | grep "$2" >/dev/null 2>&1
  else
    type "$1" >/dev/null 2>&1
  fi
}

# anyenv
echo "===== Initialize anyenv ====="
sleep 0.5
has "anyenv" || (echo "Please install anyenv." 1>&2 && exit 1)
if [[ -d "$HOME/.config/anyenv/anyenv-install" ]]; then
  echo "anyenv is already initialized"
else
  anyenv install --init
fi
echo ""
echo "path: $(which anyenv)"
echo ""

# rbenv
echo "===== Install rbenv via anyenv ====="
sleep 0.5
if has "rbenv"; then
  echo "rbenv is already installed"
else
  anyenv install rbenv
  eval "$(anyenv init -)"
fi
echo ""
echo "path: $(which rbenv)"
echo ""

# nodenv
echo "===== Install nodenv via anyenv ====="
sleep 0.5
if has "nodenv"; then
  echo "already installed"
else
  anyenv install nodenv
  eval "$(anyenv init -)"

  # https://qiita.com/tea-red/items/361c72df55b3fcd0e0bf
  touch "$(nodenv root)/default-packages"
fi
echo ""
echo "path: $(which nodenv)"
echo ""

# ruby
echo "===== Install ruby via rbenv ====="
sleep 0.5
if has "ruby" ".rbenv"; then
  echo "already installed"
else
  eval "$(rbenv init -)"
  rbenv install 2.6.3
  rbenv global 2.6.3
  rbenv rehash
fi
echo ""
echo "path: $(which ruby)"
echo "version: $(ruby -v)"
echo ""

# bundler
echo "===== Install bundler via gem ====="
sleep 0.5
if has "bundle"; then
  echo "already installed"
else
  gem install bundler
fi
echo ""
echo "path: $(which bundler)"
echo "version: $(bundler -v)"
echo ""

# node
echo "===== Install node via nodenv ====="
sleep 0.5
if has "node" ".nodenv"; then
  echo "already installed"
else
  eval "$(nodenv init -)"
  nodenv install 10.13.0
  nodenv global 10.13.0
  nodenv rehash
fi
echo ""
echo "node_path: $(which node)"
echo "node_version: $(node -v)"
echo ""
echo "npm_path: $(which npm)"
echo "npm_version: $(npm -v)"
echo ""
