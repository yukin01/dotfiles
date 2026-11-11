// keys.json の mod.open から呼ぶマクロ: worktree 作成ダイアログ (kb-worktree) を開き、上 claude / 下 shell + Files パネルの space を作る。
// mod.open は props を渡せないため、この mod を経由して openOverlay する。
import { View, div } from "gpui-kit";
import { closeOverlay, openOverlay, focused, props } from "herdr";

export default class WorktreeNew extends View {
  init() {
    const p = props();
    // overlay 以外 (herdr-app check 等) で読み込まれた時は何もしない
    if (!p?.overlay) return;
    closeOverlay(p.overlay);
    const f = focused();
    if (!f?.space) return;
    openOverlay({ mod: "kb-worktree", kind: "dialog", width: 440, height: 260,
      props: { space: f.space, folder: f.cwd ?? undefined, action: "new", argv: ["claude"], split: true, files: true } });
  }
  render() { return div(); }
}
