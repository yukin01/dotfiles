// [kb] エージェントが作業している worktree (別リポジトリも含む) を選び、分岐元からの差分を hunk で新しいタブに開く
import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { exec, hc, home, theme, props, closeOverlay } from "herdr";

// 候補ごとに top / repo / branch / 分岐元との merge-base を出す。
// 分岐元は origin/HEAD、無ければ origin/main・origin/master。どれも無ければ空 (未コミットの変更だけ見る)。
// origin は fetch しない (開くたびに待たせないため)。古ければ分岐元の判定がずれるだけ
const GATHER = `
for d in "$@"; do
  top=$(git -C "$d" rev-parse --show-toplevel 2>/dev/null) || continue
  main=$(git -C "$top" worktree list --porcelain | sed -n '1s/^worktree //p')
  branch=$(git -C "$top" branch --show-current)
  base=$(git -C "$top" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
  if [ -z "$base" ]; then
    for c in origin/main origin/master; do
      git -C "$top" rev-parse -q --verify "$c" >/dev/null && { base=$c; break; }
    done
  fi
  mb=""
  [ -n "$base" ] && mb=$(git -C "$top" merge-base "$base" HEAD 2>/dev/null)
  printf '%s\\t%s\\t%s\\t%s\\t%s\\n' "$top" "$(basename "$main")" "$branch" "$base" "$mb"
done`;

const RANK = { blocked: 0, working: 1, done: 2, idle: 3 };

export default class HunkPicker extends View {
  init(_props, cx) {
    const p = props();
    if (!p?.overlay) return;
    this.overlay = p.overlay;
    this.items = null;
    this.error = null;
    this.filter = "";
    this.at = 0;
    this.input = InputState.new({ placeholder: "Review a worktree's changes…" });
    this.input.on("change", (_e, cx) => { this.filter = this.input.value(); this.at = 0; cx.notify(); });
    this.input.on("submit", (_e, _cx) => this.open(this.rows()[this.at]));
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    cx.spawn(async (cx) => {
      try { this.items = await this.gather(); }
      catch (e) { this.error = String(e); }
      cx.notify();
    });
  }

  async gather() {
    const agents = [];
    const ls = await hc(["ls", "--json"]);
    if (ls.code === 0) {
      for (const t of JSON.parse(ls.stdout).terminals ?? []) {
        if (t.state === "live" && t.agent === "claude-code" && t.cwd) agents.push(t);
      }
    }
    const dirs = await exec("sh", ["-c", 'for d in "$1"/.herdr/worktrees/*/*/; do [ -d "$d" ] && printf "%s\\n" "\${d%/}"; done', "_", home()]);
    const candidates = [...new Set([...(dirs.stdout ?? "").split("\n").filter(Boolean), ...agents.map((a) => a.cwd)])];
    if (!candidates.length) return [];
    const r = await exec("bash", ["-c", GATHER, "_", ...candidates], { timeout: 20000 });
    const byTop = new Map();
    for (const line of (r.stdout ?? "").split("\n").filter(Boolean)) {
      const [top, repo, branch, base, mb] = line.split("\t");
      if (byTop.has(top)) continue;
      const inside = (cwd) => cwd === top || cwd.startsWith(top + "/");
      const status = agents.filter((a) => inside(a.cwd)).map((a) => a.status).filter(Boolean)
        .sort((a, b) => (RANK[a] ?? 9) - (RANK[b] ?? 9))[0] ?? null;
      byTop.set(top, { top, repo, branch: branch || "(detached)", base, mb, status });
    }
    return [...byTop.values()].sort((a, b) =>
      (RANK[a.status] ?? 9) - (RANK[b.status] ?? 9) || `${a.repo}/${a.branch}`.localeCompare(`${b.repo}/${b.branch}`));
  }

  rows() {
    const f = this.filter.toLowerCase();
    return (this.items ?? []).filter((i) => !f || `${i.repo} ${i.branch} ${i.top}`.toLowerCase().includes(f));
  }

  open(item) {
    if (!item) return;
    closeOverlay(this.overlay);
    // 開き方 (既存の hunk の再利用、分岐元の判定) は claude のスキルと揃えるため herdr-app-hunk に任せる
    exec(`${home()}/dotfiles/bin/herdr-app-hunk`, [item.top], { timeout: 30000 });
  }

  render(cx) {
    if (!this.overlay) return div();
    const t = theme(), rows = this.rows();
    if (this.at >= rows.length) this.at = Math.max(0, rows.length - 1);
    const color = { blocked: t.blocked, working: t.ansi3, done: t.done ?? t.ansi2, idle: t.dim };
    const tilde = (p) => (p.startsWith(home()) ? "~" + p.slice(home().length) : p);
    return v_flex().id("kb-hunk").size_full().min_h(0).p(18).gap(10).bg(t.popover).text_size(13).text_color(t.foreground)
      .on_key_down((e, cx) => {
        if (e.key === "escape") return closeOverlay(this.overlay);
        if (e.key === "down" && rows.length) this.at = (this.at + 1) % rows.length;
        else if (e.key === "up" && rows.length) this.at = (this.at + rows.length - 1) % rows.length;
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(div().text_size(15).font_semibold().child("Review changes"))
      .child(h_flex().h(36).flex_none().px(10).items_center().rounded(9).border_1().border_color(t.accent).bg(t.background)
        .child(Input.new(this.input).flex_1().h_full().text_size(12.8)))
      // popup の高さは中身で決まり、flex_1 では潰れるため高さを明示する
      .child(v_flex().id("kb-hunk-list").h(Math.max(40, Math.min(440, rows.length * 40))).flex_none().overflow_y_scrollbar()
        .when(this.items === null || this.error || rows.length === 0, (el) => el.child(div().p(8).text_color(t.dim)
          .child(this.error ?? (this.items === null ? "Looking for worktrees…" : "No worktrees"))))
        .children(rows.map((i, n) => h_flex().id(`kb-hunk-${n}`).flex_none().mx(4).px(10).h(40).gap(10).items_center().rounded(7).cursor_pointer()
          .when(n === this.at, (el) => el.bg(t.hover)).hover((s) => s.bg(t.hover))
          .on_click(() => this.open(i))
          .child(v_flex().flex_1().min_w(0)
            .child(div().truncate().child(`${i.repo} / ${i.branch}`))
            .child(div().truncate().text_size(11).text_color(t.dim).child(`${tilde(i.top)}  ·  vs ${i.base || "HEAD (uncommitted only)"}`)))
          .when(Boolean(i.status), (el) => el.child(div().text_size(11).text_color(color[i.status] ?? t.dim).child(i.status))))));
  }
}
