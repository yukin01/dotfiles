#!/bin/bash
set -eu

# oh-my-zsh
echo "===== install oh-my-zsh ====="
if [ -d ~/.oh-my-zsh ]; then
    echo "already installed"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ./fonts/install.sh
    cp ./cobalt2/cobalt2.zsh-theme ~/.oh-my-zsh/themes/
    echo "please change iTerm2 settings"
fi

set +e

# ruby
echo "===== install ruby via rbenv ====="
eval "$(rbenv init -)"
rbenv install 2.5.1
rbenv global 2.5.1
rbenv rehash
echo "\npath: $(which ruby)\nversion: $(ruby -v)\n"

# bundler
echo "===== install bundler via gem ====="
gem install bundler
echo "\npath: $(which bundler)\nversion: $(bundler -v)\n"

# node
echo "===== install node via nodebrew ====="
mkdir -p ~/.nodebrew/src
nodebrew install stable
nodebrew use stable
echo "\nnode_path: $(which node)\nnode_version: $(node -v)"
echo "npm_path: $(which npm)\nnpm_version: $(npm -v)\n"

# go
echo "===== install go via goenv ====="
goenv install 1.11.2
goenv global 1.11.2
goenv rehash
echo "\npath: $(which go)\nversion: $(go version)"

echo "\nInstalled successfully"
