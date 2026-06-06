# Neovim configuration

dotfiles で管理している neovim 設定。Lua + [lazy.nvim](https://github.com/folke/lazy.nvim) ベース。

引数なしで `nvim` を起動すると snacks.nvim の dashboard が表示され、主要キーマップが一覧できる。

## ディレクトリ構成

```
.config/nvim/
├── init.lua              -- エントリポイント (leader 設定 + require)
├── lazy-lock.json        -- プラグインバージョン固定 (git tracked)
└── lua/
    ├── config/
    │   ├── options.lua   -- 基本設定 (clipboard, tab, search 等)
    │   ├── keymaps.lua   -- 基本キーマップ (j/k, <Esc><Esc>)
    │   └── lazy.lua      -- lazy.nvim ブートストラップ
    └── plugins/
        ├── colorscheme.lua  -- Mofiqul/dracula.nvim
        ├── lualine.lua      -- nvim-lualine/lualine.nvim
        ├── snacks.lua       -- folke/snacks.nvim (dashboard)
        ├── neo-tree.lua     -- nvim-neo-tree/neo-tree.nvim (サイドバー)
        ├── fzf.lua          -- ibhagwan/fzf-lua
        └── lazygit.lua      -- kdheepak/lazygit.nvim

> シンタックスハイライト: neovim 0.12 で tree-sitter が本体統合 (`nvim-treesitter` は 2026-04 に archived)。
> パーサー同梱の言語は自動でハイライトされるため、プラグインは入れていない。
```

## キーマップ

leader = **`<Space>`**

### ファイラ / ナビゲーション

| キー | 動作 |
|---|---|
| `<leader>e` | Neotree toggle (常時サイドバー) |
| `<leader>o` | Neotree にフォーカス |

> ターミナルで素早くファイル探索したい場合は cmux pane の yazi (左上 surface) を使う。nvim 内には yazi プラグインは入れない方針。

サイドバーは `nvim` (引数なし) または `nvim .` (ディレクトリ指定) で起動した場合に自動で開く。引数なし時は中央に dashboard、左にサイドバーが並ぶ。

#### Neotree 内の操作 (focus 中)

| キー | 動作 |
|---|---|
| `Enter` / `o` | 開く / 展開 |
| `a` / `d` / `r` | 作成 / 削除 / リネーム |
| `c` / `m` | コピー / 移動 |
| `H` | 隠しファイル toggle (gitignored 含む) |
| `?` | ヘルプ |
| `q` | 閉じる |

### 検索 (fzf-lua)

| キー | 動作 |
|---|---|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | grep (全文検索) |
| `<leader>fb` | バッファ一覧 |
| `<leader>fh` | ヘルプタグ検索 |
| `<leader>fr` | 直前の fzf 結果を再開 (resume) |

### git (LazyGit)

| キー | 動作 |
|---|---|
| `<leader>gg` | LazyGit を開く |
| `<leader>gf` | LazyGit (現在ファイルを focus) |

> cmux pane 側にも lazygit が別途存在する。nvim 内 lazygit は編集と git 操作を行き来する用、cmux pane の lazygit は独立した長時間作業用、と棲み分けると良い。

### 基本

| キー | 動作 |
|---|---|
| `j` / `k` | 表示行単位の移動 (`gj` / `gk`) |
| `<Esc><Esc>` | 検索ハイライト解除 |

## プラグイン管理 (lazy.nvim)

### 基本コマンド

| コマンド | 動作 |
|---|---|
| `:Lazy` | ダッシュボード (UI) |
| `:Lazy check` | リモートに更新があるか fetch して確認 |
| `:Lazy update` | プラグイン更新 (git pull) |
| `:Lazy sync` | install + clean + update を一括 |
| `:Lazy clean` | 不要プラグインの削除 |
| `:Lazy restore` | `lazy-lock.json` の状態に復元 |
| `:Lazy log` | 更新ログ |

`:Lazy` UI 上では `U`(update) / `C`(check) / `S`(sync) / `?`(help) などのショートカットが効く。

### 自動チェック

`lua/config/lazy.lua` で `checker = { enabled = true, notify = false }` 設定。
起動後にバックグラウンドで更新の有無だけチェックし、通知は出さない。`:Lazy` を開くと「○個更新あり」が見える。

### lockfile の運用

- `lazy-lock.json` は git tracked (再現性のため)
- 更新リズム: 月 1 程度で `:Lazy update` → 問題なければ `lazy-lock.json` を commit
- 壊れた時のロールバック: `git restore files/.config/nvim/lazy-lock.json` → `:Lazy restore`

### nvim 本体の更新

`brew upgrade neovim`。プラグインが新しい nvim を要求することがあるので、定期的に。

## カスタマイズ指針

- **テーマ変更**: `lua/plugins/colorscheme.lua` の repo と、`lua/plugins/lualine.lua` の `theme` を差し替え
  - 候補: `folke/tokyonight.nvim`, `catppuccin/nvim`, `rebelot/kanagawa.nvim`
- **leader 変更**: `init.lua` の `vim.g.mapleader` を変更 (例: `","`)
- **新規プラグイン追加**: `lua/plugins/` 配下に `<name>.lua` を作って `return { ... }` で spec を返す
- **Neotree 自動起動を止めたい**: `lua/plugins/neo-tree.lua` の `init` 関数の autocmd を削除

## インストール

dotfiles を `~/dotfiles` に展開済みの前提:

```sh
brew bundle           # neovim を含む依存をインストール
nvim                  # 初回起動 → lazy.nvim 自動 bootstrap → プラグイン install
```
