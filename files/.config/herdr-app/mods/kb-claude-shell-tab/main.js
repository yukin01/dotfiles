// keys.json の mod.open から呼ぶマクロ: 現在の space に claude(上 0.7) / shell(下 0.3) のタブを作る。
// keys.json のアクションは単一コマンドしか書けないため、overlay として開いて即閉じる mod で連鎖させる。
import { View, div } from "gpui-kit";
import { run, closeOverlay, props } from "herdr";
// mod の外は import できないため kb-worktree/split.js の複製を置いている
import { splitClaudeShell } from "./split.js";

export default class ClaudeShellTab extends View {
  init(_props, cx) {
    const p = props();
    // overlay 以外 (herdr-app check 等) で読み込まれた時は何もしない
    if (!p?.overlay) return;
    cx.spawn(async (cx) => {
      await splitClaudeShell(cx, () => run("tab.new", { argv: ["claude"] }));
      closeOverlay(p.overlay);
    });
  }
  render() { return div(); }
}
