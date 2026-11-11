// keys.json の mod.open から呼ぶマクロ: 組み込み worktree ダイアログ (action: "remove") を開く。
// mod.open は props を渡せないため、この mod を経由して openOverlay する。
import { View, div } from "gpui-kit";
import { closeOverlay, openOverlay, focused, props } from "herdr";

export default class WorktreeRemove extends View {
  init() {
    const p = props();
    // overlay 以外 (herdr-app check 等) で読み込まれた時は何もしない
    if (!p?.overlay) return;
    closeOverlay(p.overlay);
    const f = focused();
    if (!f?.space) return;
    openOverlay({ mod: "worktree", kind: "dialog", width: 440, height: 260,
      props: { space: f.space, folder: f.cwd ?? undefined, action: "remove" } });
  }
  render() { return div(); }
}
