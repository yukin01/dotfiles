#!/bin/bash
set -eu

# ruby
echo "===== install ruby via rbenv ====="
sleep 0.5
if which ruby | grep .rbenv >/dev/null; then 
    echo "already installed"
else
    eval "$(rbenv init -)"
    rbenv install 2.5.1
    rbenv global 2.5.1
    rbenv rehash
fi
echo ""
echo "path: $(which ruby)"
echo "version: $(ruby -v)"
echo ""

# bundler
echo "===== install bundler via gem ====="
sleep 0.5
# one liner sample
# which bundle > /dev/null 2>&1 || gem install bundler
if which bundle > /dev/null; then
    echo "already installed"
else
    gem install bundler
fi
echo ""
echo "path: $(which bundler)"
echo "version: $(bundler -v)"
echo ""

# node
echo "===== install node via nodebrew ====="
sleep 0.5
if which node | grep .nodebrew >/dev/null; then 
    echo "already installed"
else
    mkdir -p ~/.nodebrew/src
    nodebrew install stable
    nodebrew use stable
fi
echo ""
echo "node_path: $(which node)"
echo "node_version: $(node -v)"
echo ""
echo "npm_path: $(which npm)"
echo "npm_version: $(npm -v)"
echo ""

# go
echo "===== install go via goenv ====="
sleep 0.5
if which go | grep .goenv >/dev/null; then 
    echo "already installed"
else
    goenv install 1.11.2
    goenv global 1.11.2
    goenv rehash
fi
echo ""
echo "path: $(which go)"
echo "version: $(go version)"
echo ""

# oh-my-zsh
echo "===== install oh-my-zsh ====="
sleep 0.5
if [ -d ~/.oh-my-zsh ]; then
    echo "already installed"
else
    # oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    # powerline (font)
    ./fonts/install.sh
    # cobalt2 (zsh-theme)
    cp ./cobalt2/cobalt2.zsh-theme ~/.oh-my-zsh/themes/
    
    echo ""
    echo "please change iTerm2 settings"
    echo ""
    echo "    1. iTerm2 > Preferences > Profiles"
    echo "    2. Under the Colors tab import the cobalt2.itermcolors."
    echo "    3. Under the Text tab change the font for each type (Regular and Non-ASCII) to powerline."
    echo ""
    echo "    https://github.com/wesbos/Cobalt2-iterm"
    echo ""
fi
echo ""

echo "Installed successfully"

