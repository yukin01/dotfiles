---
name: herdr-app-spawn
description: Herdr デスクトップアプリ (herdr-app) 上に git worktree 付きの別 Claude Code セッションを立ち上げ、タスクのプロンプトを流し込んで並列に作業させる。「別セッションで〜して」「並列で〜やらせて」「worktree 切って claude に〜させて」「spawn して」など、ユーザーが別セッション・別 worktree への委譲を明示的に求めたときに使う。結果の回収 (「さっきの spawn の結果見て」) にも使う。単に作業が並列化できそうというだけでは使わない。Requires HC_TERMINAL_ID (旧 herdr の中なら spawn スキルを使う).
---

# herdr-app-spawn

`herdr-app-open` (dotfiles の `bin/herdr-app-open`) で worktree と claude/shell の space を作り、claude に最初のプロンプトを送る。起動した claude は herdr-core のターミナルとして動き、`hc` で状態の確認、出力の読み取り、追加の指示ができる。

ユーザーがこのスキルを呼んだこと自体を、space と worktree の作成依頼として扱う。herdr-app スキルの「頼まれたときだけ space を作る」方針より、このスキルの手順を優先する。

## 前提確認

```bash
test -n "${HC_TERMINAL_ID:-}"
```

失敗したら止まる。`HERDR_ENV=1` なら「旧 herdr の中なので spawn スキルを使う」、どちらでもなければ「herdr-app の外で動いているので spawn できない」と伝える。

## 起動

1. **リポジトリ**: ユーザーが指定しなければ、現在の作業ディレクトリのリポジトリを使う。
2. **ブランチ名**: タスク内容から短い kebab-case を決める。`feat-` / `fix-` / `research-` / `chore-` などの接頭辞を付ける (例: `research-emudhra-impact`)。worktree は `~/.herdr/worktrees/<repo>/<branch>` にでき、space の名前もこのフォルダ名になる。
3. **プロンプト**: 新しいセッションは (fork しない限り) この会話の文脈を持たない。目的、背景、対象のファイルやリポジトリ、制約、完了条件、成果物の形 (例: 「コミットまで」「PR は作らない」「調査結果を Markdown で報告」) を、それだけで作業できるように書く。ユーザーの依頼を勝手に広げない。
4. **実行**:

   ```bash
   herdr-app-open --no-focus -p "<prompt>" -w <branch> <repo-path>
   ```

   - オプションは path より前に置く。
   - 分岐元は origin の default branch (fetch してから)。origin が無ければ HEAD。同名のブランチが既にあればそれを checkout する。worktree のパスが既にあると `git worktree add` で失敗するので、別のブランチ名で再実行する。
   - ユーザーが「コンテキストを引き継いで」「この会話ごと fork して」などと求めたときだけ、`-f "$CLAUDE_CODE_SESSION_ID"` を足す。今のセッションを `--resume --fork-session` で分岐させ、会話の文脈を持ったまま起動する。
     - herdr-app ではまだ確認していない。旧 herdr では同じリポジトリの worktree からの fork でだけ確認した。別リポジトリでは使わない。
     - 会話全体を引き継ぐので、コンテキストを大きく消費する。
     - fork 先は、会話の中に出てくる元のリポジトリのパスを作業場所だと思い込みやすい。プロンプトに「作業ディレクトリは worktree (cwd)。元のリポジトリ <path> は編集しない」と必ず書く。
   - 成功すると `space: <id>`、`terminal: <t>` (hc のアドレス、例: `t2b`)、`cwd: <worktree path>` が出る。以降は `terminal` のアドレスで扱う。
   - `--no-focus` でも space.new が一瞬その space を表示してから元に戻る。Files パネルは開かない。
5. **報告**: terminal のアドレス、worktree のパス、送ったプロンプトの要旨を1〜3行で伝える。完了は待たない。

フォルダの trust 確認などで claude が止まると、`herdr-app-open` が `blocked: ...` を出して終わる。この場合は、Herdr で該当 space を開いて承認するようユーザーに伝える。ダイアログに自分で答えない。

## 結果の回収 (ユーザーに頼まれたときだけ)

```bash
hc wait <t> --timeout 600
hc read <t> --lines 200
```

- アドレスが分からなければ `hc ls` の `where` (space 名 / タブ番号) と `cwd` から探す。
- `hc get <t>` の `status.state` が `blocked` なら、`hc read` で内容を見てユーザーに判断を仰ぐ。勝手に承認しない。
- 追加の指示は、ユーザーが求めたときだけ `hc send <t> "<text>"` で送る。

## やらないこと

- 頼まれていない worktree、space、ターミナルの削除や終了 (`hc kill`、`space.close`、`git worktree remove` など)。
- spawn したセッションの成果物を、こちらのセッションで勝手にマージや push すること。
