---
name: herdr-app-hunk
description: Herdr デスクトップアプリ (herdr-app) のタブで hunk (ターミナルの diff ビューア) を開き、ユーザーが見ている差分の画面を `hunk session` で操作しながら説明・レビューする。「hunk 開いて」「差分見せて」「〜の worktree の diff を見たい」「hunk でレビューして」など、ユーザーが差分の表示や hunk を使ったレビューを求めたときに使う。単に git diff の内容を知りたいだけなら使わない。Requires HC_TERMINAL_ID.
---

# herdr-app-hunk

`herdr-app-hunk` (dotfiles の `bin/herdr-app-hunk`) で hunk をタブに開き、以降は hunk 同梱のスキル (hunk-review) の手順で、`hunk session` の CLI からその画面を操作する。

## 前提確認

```bash
test -n "${HC_TERMINAL_ID:-}"
```

失敗したら「herdr-app の外なので hunk のタブを開けない」と伝えて止まる。

## 開く

1. **対象**: ユーザーが指定しなければ、現在の作業ディレクトリのリポジトリ。worktree やブランチ名で指定されたら、`~/.herdr/worktrees/<repo>/<branch>` や `git worktree list` から探す。見つからない、または候補が複数あるときはユーザーに聞く。
2. **実行**:

   ```bash
   herdr-app-hunk <path>
   ```

   - 分岐元 (origin/HEAD など) との merge-base から作業ツリーまでの差分を出す。分岐してからのコミットと未コミットの変更をまとめて見せる。
   - 同じリポジトリの hunk が既に開いていれば、そのタブを表示して差分を読み直す。無ければ新しいタブで開く。どちらも画面が切り替わる。
   - 成功すると `session: <id>`、`repo: <path>`、`base: <ref>` が出る。以降の `hunk session` には `<id>` を渡す (同じリポジトリのセッションが複数あっても取り違えないため)。

## 操作する

`hunk skill path` が返す SKILL.md を Read で読み、その手順に従う。要点:

- 画面 (TUI) は人のもの。`hunk diff` などの対話コマンドを自分で実行しない。
- `hunk session review <id> --json` で構造を読み、必要なときだけ `--include-patch` で本文を取る。
- 説明している箇所へ `hunk session navigate` で移動し、`hunk session highlight add` で示す。
- レビューを頼まれたときだけ `hunk session comment add` / `apply` で行にコメントを残す。頼まれていないのに大量のコメントを付けない。

差分の対象を変えるとき (別のコミット、staged だけなど) は `hunk session reload <id> -- diff ...` を使う。

## やらないこと

- ユーザーのコメント (`--type user`) の削除や、`comment clear --include-user` / `--all`。
- hunk のタブを勝手に閉じること。
