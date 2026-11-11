import { useExec } from "@raycast/utils";
import { homedir } from "node:os";
import { join } from "node:path";
import { PATH, RepoList, run, shellEscape } from "./repo-list";

// herdr サーバーが落ちていれば headless で起動し、socket が開くまで待つ
const ENSURE_SERVER = [
  `herdr workspace list >/dev/null 2>&1`,
  `|| { (herdr server >/dev/null 2>&1 &) ;`,
  `for i in {1..20}; do herdr workspace list >/dev/null 2>&1 && break; sleep 0.25; done }`,
].join(" ");

// Ghostty 起動済みなら前面へ、未起動なら herdr にアタッチした状態で起動
const OPEN_GHOSTTY = `if pgrep -xq ghostty; then open -a Ghostty; else open -na Ghostty --args -e herdr; fi`;

// focus-or-create + レイアウト構築は herdr-open に委譲
const HERDR_OPEN = join(homedir(), "dotfiles/bin/herdr-open");

function openInHerdr(fullPath: string, label: string) {
  const cmd = `${shellEscape(HERDR_OPEN)} ${shellEscape(fullPath)} ${shellEscape(label)}`;
  run(`{ ${ENSURE_SERVER}; } && ${cmd} && ${OPEN_GHOSTTY}`);
}

function parseWorkspaces(stdout: string): Record<string, string> {
  try {
    const data = JSON.parse(stdout);
    const map: Record<string, string> = {};
    for (const ws of data.result.workspaces ?? []) {
      map[ws.label] = ws.workspace_id;
    }
    return map;
  } catch {
    return {};
  }
}

export default function Command() {
  const { data: workspaces } = useExec("herdr", ["workspace", "list"], {
    env: { PATH },
    parseOutput: ({ stdout }) => parseWorkspaces(stdout),
  });

  return (
    <RepoList
      openTitle="Open in Herdr"
      open={({ fullPath, title }) => openInHerdr(fullPath, title)}
      isActive={({ title }) => Boolean(workspaces?.[title])}
    />
  );
}
