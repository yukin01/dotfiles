---
name: spawn
description: herdr 上に git worktree 付きの別 Claude Code セッションを立ち上げ、タスクのプロンプトを流し込んで並列に作業させる。「別セッションで〜して」「並列で〜やらせて」「worktree 切って claude に〜させて」「spawn して」など、ユーザーが別セッション・別 worktree への委譲を明示的に求めたときに使う。結果の回収 (「さっきの spawn の結果見て」) にも使う。単に作業が並列化できそうというだけでは使わない。Requires HERDR_ENV=1.
---

# spawn

`herdr-open` (dotfiles の `bin/herdr-open`) で worktree と nvim/shell/claude のレイアウトを作り、claude を名前付きの herdr agent として起動して最初のプロンプトを送る。

ユーザーがこのスキルを呼んだこと自体を、workspace と worktree の作成依頼として扱う。herdr スキルの「既定では隣のペインに分割する」方針より、このスキルの手順を優先する。

## 前提確認

```bash
test "${HERDR_ENV:-}" = 1
```

失敗したら「herdr の外で動いているので spawn できない」と伝えて止まる。

## 起動

1. **リポジトリ**: ユーザーが指定しなければ、現在の作業ディレクトリのリポジトリを使う。
2. **ブランチ名とエージェント名**: タスク内容から短い kebab-case を決め、両方に同じ名前を使う。`feat-` / `fix-` / `research-` / `chore-` などの接頭辞を付ける (例: `research-emudhra-impact`)。エージェント名は `[a-z][a-z0-9_-]{0,31}` に収める。
3. **プロンプト**: 新しいセッションは (fork しない限り) この会話の文脈を持たない。目的、背景、対象のファイルやリポジトリ、制約、完了条件、成果物の形 (例: 「コミットまで」「PR は作らない」「調査結果を Markdown で報告」) を、それだけで作業できるように書く。ユーザーの依頼を勝手に広げない。
4. **実行**:

   ```bash
   herdr-open --no-focus -n <name> -p "<prompt>" -w <branch> <repo-path>
   ```

   - オプションは `-w` より前に置く (`-w` の直後の引数を branch とみなすため)。
   - ユーザーが「コンテキストを引き継いで」「この会話ごと fork して」などと求めたときだけ、`-f "$CLAUDE_CODE_SESSION_ID"` を足す。今のセッションを `--resume --fork-session` で分岐させ、会話の文脈を持ったまま起動する。
     - 同じリポジトリの worktree でしか確認していない。別リポジトリでは使わない。
     - 会話全体を引き継ぐので、コンテキストを大きく消費する。
     - fork 先は、会話の中に出てくる元のリポジトリのパスを作業場所だと思い込みやすい。プロンプトに「作業ディレクトリは worktree (cwd)。元のリポジトリ <path> は編集しない」と必ず書く。
   - 成功すると `agent: <name>` と `cwd: <worktree path>` が出る。
   - `agent name already in use` が出たら、別の名前で再実行する。
5. **報告**: エージェント名、worktree のパス、送ったプロンプトの要旨を1〜3行で伝える。完了は待たない。

フォルダの trust 確認などで claude が止まると、`herdr-open` が承認待ちのメッセージを出して最大5分待つ。この場合は、herdr で該当 workspace を開いて承認するようユーザーに伝える。ダイアログに自分で答えない。

## 結果の回収 (ユーザーに頼まれたときだけ)

```bash
herdr agent wait <name> --timeout 600000
herdr agent read <name> --source recent-unwrapped --lines 200
```

- `blocked` なら、`agent read` で内容を見てユーザーに判断を仰ぐ。勝手に承認しない。
- 追加の指示は、ユーザーが求めたときだけ `herdr agent prompt <name> "<text>"` で送る。

## やらないこと

- 頼まれていない worktree、workspace、エージェントの削除や終了 (`herdr worktree remove` など)。
- spawn したセッションの成果物を、こちらのセッションで勝手にマージや push すること。
