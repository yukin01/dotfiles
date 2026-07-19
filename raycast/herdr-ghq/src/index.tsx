import { Action, ActionPanel, List, closeMainWindow } from "@raycast/api";
import { useExec } from "@raycast/utils";
import { spawn } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";

const PATH = [
  join(homedir(), ".local/share/mise/shims"),
  "/opt/homebrew/bin",
  "/usr/local/bin",
  "/usr/bin",
  process.env.PATH,
].join(":");

const ENV = { ...process.env, PATH };

const EXTRA_DIRS = [join(homedir(), "dotfiles"), join(homedir(), "workfiles")];

type Entry = {
  fullPath: string;
  title: string;
  subtitle: string;
};

function run(command: string) {
  const child = spawn("/bin/zsh", ["-c", command], {
    env: ENV,
    detached: true,
    stdio: "ignore",
  });
  child.unref();
}

function shellEscape(s: string) {
  return `'${s.replace(/'/g, "'\\''")}'`;
}

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
  const {
    data: ghqRoot,
    isLoading: isLoadingRoot,
    error: rootError,
  } = useExec("ghq", ["root"], {
    env: { PATH },
    parseOutput: ({ stdout }) => stdout.trim(),
  });

  const {
    data: repos,
    isLoading: isLoadingList,
    error: listError,
  } = useExec("ghq", ["list"], {
    env: { PATH },
    parseOutput: ({ stdout }) =>
      stdout
        .trim()
        .split("\n")
        .filter((line) => line.length > 0),
  });

  const { data: workspaces } = useExec("herdr", ["workspace", "list"], {
    env: { PATH },
    parseOutput: ({ stdout }) => parseWorkspaces(stdout),
  });

  if (rootError || listError) {
    console.error("ghq error:", rootError?.message ?? listError?.message);
  }

  const extraEntries: Entry[] = EXTRA_DIRS.map((dir) => ({
    fullPath: dir,
    title: dir.split("/").pop() ?? dir,
    subtitle: "local",
  }));

  const ghqEntries: Entry[] = (repos ?? []).map((repo) => {
    const parts = repo.split("/");
    return {
      fullPath: ghqRoot ? join(ghqRoot, repo) : repo,
      title: parts.length >= 3 ? parts.slice(1).join("/") : repo,
      subtitle: parts[0],
    };
  });

  const entries = [...extraEntries, ...ghqEntries];

  return (
    <List
      isLoading={isLoadingRoot || isLoadingList}
      searchBarPlaceholder="Search repositories..."
    >
      {entries.map((entry) => {
        const { fullPath, title, subtitle } = entry;

        return (
          <List.Item
            key={fullPath}
            title={title}
            subtitle={subtitle}
            accessories={
              workspaces?.[title] ? [{ tag: { value: "active" } }] : undefined
            }
            actions={
              <ActionPanel>
                <Action
                  title="Open in Herdr"
                  onAction={async () => {
                    await closeMainWindow();
                    openInHerdr(fullPath, title);
                  }}
                />
                <Action
                  title="Open in VS Code"
                  shortcut={{ modifiers: ["cmd"], key: "o" }}
                  onAction={async () => {
                    await closeMainWindow();
                    run(`code ${shellEscape(fullPath)}`);
                  }}
                />
                <Action.CopyToClipboard
                  title="Copy Path"
                  content={fullPath}
                  shortcut={{ modifiers: ["cmd", "shift"], key: "c" }}
                />
              </ActionPanel>
            }
          />
        );
      })}
    </List>
  );
}
