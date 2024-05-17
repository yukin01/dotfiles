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
$ ./scripts/01-setup-ssh.sh
```


### Git

Configure git remote repo.

```bash
$ ./scripts/02-setup-git.sh
```


### Homebrew

Install *Homebrew* and packages.

```bash
$ ./scripts/03-setup-homebrew.sh
```

For `kubectl`, don't enable *Docker for Mac*'s k8s option before installing *Minikube*.


### Tools

```bash
$ ./scripts/04-setup-asdf.sh
$ ./scripts/05-setup-tools.sh
```

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
/opt/homebrew/bin/zsh # for Apple Silicon

$ chsh -s /usr/local/bin/zsh
$ chsh -s /opt/homebrew/bin/zsh # for Apple Silicon
```


### iTerm2

- color theme: [Dracula](https://github.com/dracula/iterm)
- font: [HackGen35 Console NF](https://github.com/yuru7/HackGen)


### Manual

- Disable *Spotlight* shortcut
  - https://manual.raycast.com/hotkey
- System Settings > Keyboard > Text Input > Edit...
  - Add Google Japanese IME
  - Disable below
    - *Use smart quotes and dashes*
    - *Correct spelling automatically*
    - *Capitalize words automatically*
    - *Show inline predictive text*
    - *Add period with double-space*
  - Swap CapsLock and Ctrl
- Login below
  - Visual Studio Code
  - Google Chrome
  - Dash, Fig


## Ubuntu

<details>
<summary>Deprecated</summary>

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

</details>


## References

- [Generating a new SSH key and adding it to the ssh-agent](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [お前らのSSH Keysの作り方は間違っている](https://qiita.com/suthio/items/2760e4cff0e185fe2db9)
- [ログインシェルとインタラクティブシェルと~/.bashrc達の関係](https://qiita.com/incep/items/7e5760de0c2c748296aa)
- [zshの設定ファイルの読み込み順序と使い方Tipsまとめ](https://qiita.com/muran001/items/7b104d33f5ea3f75353f)
- [DockerのVolumeマウントのオーナーとfixuidとeuid](https://bufferings.hatenablog.com/entry/2018/08/26/015035)
- [優れた dotfiles を設計して、最速で環境構築する話](https://qiita.com/b4b4r07/items/24872cdcbec964ce2178)
- [なぜ今シェルスクリプトを学ぶのか・シェルスクリプトのTips](https://kiririmode.hatenablog.jp/entry/20220430/1651309058)
- [dotfilesリポジトリで管理したgitconfigはHOMEではなくXDG_CONFIG_HOME配下に置くとよい](https://horimisli.me/entry/git-config-location/)
- [dotfilesのこだわりを晒す](https://www.m3tech.blog/entry/dotfiles-bonsai)
- [M1のMacにHomebrewをインストールしてPATHを通す](https://motomichi-works.hatenablog.com/entry/2022/02/06/000215)
