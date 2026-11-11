// [kb] claude(上) / shell(下) の分割。kb-claude-shell-tab と kb-worktree に同じものを置いている。
// open() は claude だけの新しいタブ (または space) を作る関数。
import { run, focused, panes } from "herdr";

export async function splitClaudeShell(cx, open) {
  open();
  run("pane.split", { direction: "down" });
  // 直後は focused() / panes() がまだ新しいタブを指さず、pane.go も split のフォーカス移動に上書きされるため待つ
  await cx.sleep(150);
  const tab = focused()?.tab;
  const [claude, shell] = panes().filter((p) => p.tab === tab);
  // pane.split に比率指定がないため layout.resize で pane の weight を後から決める
  if (claude && shell) {
    run("layout.resize", { id: claude.pane, weight: 0.7 });
    run("layout.resize", { id: shell.pane, weight: 0.3 });
    run("pane.focus", { pane: claude.pane });
  } else {
    run("pane.go", { direction: "up" });
  }
}
