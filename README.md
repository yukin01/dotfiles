# Dotfiles
My environment for MacOS and Ubuntu

## MacOS

### Xcode

Install *Xcode* from *App Store* and launch once.

or

```
$ xcode-select --install
```

### Installation

Clone this repo and make symlinks for dotfiles.

```bash
$ bash -c "$(curl -fsSL dot.yukin01.dev)"
```


### SSH

Generate SSH key pair.

```bash
$ ./ssh.sh
```


### Git

Configure git remote repo.

```bash
$ ./mac/00_git
```


### Homebrew

Install *Homebrew* and packages.

```bash
$ ./mac/01_homebrew
```

For `kubectl`, don't enable *Docker for Mac*'s k8s option before installing *Minikube*.


### Tools

```bash
$ ./mac/02_asdf
$ ./mac/03_setup
```

|                       name                        |                usage                |
|:-------------------------------------------------:|:-----------------------------------:|
|      [asdf](https://github.com/asdf-vm/asdf)      |  Manage multiple runtime versions   |
| [prezto](https://github.com/sorin-ionescu/prezto) | The configuration framework for Zsh |

Note: https://github.com/asdf-vm/asdf-nodejs


### Zsh

```bash
$ sudo vi /etc/shells
# List of acceptable shells for chpass(1).
# Ftpd will not allow users to connect who are not using
# one of these shells.

/bin/bash
/bin/csh
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
/usr/local/bin/zsh # Add this

$ chsh -s /usr/local/bin/zsh
```


### iTerm2

- color theme: [Dracula](https://github.com/dracula/iterm)
- font: [HackGen35Nerd Console](https://github.com/yuru7/HackGen)


### Manual

- Login shell
- Keyboard Settings
  - Google Japanese IME
  - Disable smart quotes and auto correction
  - Swap CapsLock and Ctrl
- VSCode Settings Sync
- Google Chrome login
- `gh api user`


## Ubuntu

Clone this repo.

```bash
$ bash -c "$(curl -fsSL dot.yukin01.dev)"
```

Install Powerline Fonts.

```bash
$ ./fonts/install.sh
```

Configure SSH key pair.

```bash
$ ./ssh.sh
```

Install ansible.

```bash
$ ./ansible/install.sh
```

Run ansible playbook.

```bash
$ ansible-playbook -i hosts ubuntu.yml --ask-become-pass
```


## Suggestion

- fish


## References

- [Generating a new SSH key and adding it to the ssh-agent](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [お前らのSSH Keysの作り方は間違っている](https://qiita.com/suthio/items/2760e4cff0e185fe2db9)
- [ログインシェルとインタラクティブシェルと~/.bashrc達の関係](https://qiita.com/incep/items/7e5760de0c2c748296aa)
- [zshの設定ファイルの読み込み順序と使い方Tipsまとめ](https://qiita.com/muran001/items/7b104d33f5ea3f75353f)
- [DockerのVolumeマウントのオーナーとfixuidとeuid](https://bufferings.hatenablog.com/entry/2018/08/26/015035)
- [優れた dotfiles を設計して、最速で環境構築する話](https://qiita.com/b4b4r07/items/24872cdcbec964ce2178)
- [なぜ今シェルスクリプトを学ぶのか・シェルスクリプトのTips](https://kiririmode.hatenablog.jp/entry/20220430/1651309058)
- [dotfilesリポジトリで管理したgitconfigはHOMEではなくXDG_CONFIG_HOME配下に置くとよい](https://horimisli.me/entry/git-config-location/)
