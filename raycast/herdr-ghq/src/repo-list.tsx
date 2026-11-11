import {
  Action,
  ActionPanel,
  Keyboard,
  List,
  closeMainWindow,
} from "@raycast/api";
import { useExec } from "@raycast/utils";
import { spawn } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";

export const PATH = [
  join(homedir(), ".local/share/mise/shims"),
  join(homedir(), ".local/bin"),
  "/opt/homebrew/bin",
  "/usr/local/bin",
  "/usr/bin",
  process.env.PATH,
].join(":");

const ENV = { ...process.env, PATH };

const EXTRA_DIRS = [join(homedir(), "dotfiles"), join(homedir(), "workfiles")];

export type Entry = {
  fullPath: string;
  title: string;
  subtitle: string;
};

export function run(command: string) {
  const child = spawn("/bin/zsh", ["-c", command], {
    env: ENV,
    detached: true,
    stdio: "ignore",
  });
  child.unref();
}

export function shellEscape(s: string) {
  return `'${s.replace(/'/g, "'\\''")}'`;
}

type Props = {
  openTitle: string;
  open: (entry: Entry) => void;
  isActive: (entry: Entry) => boolean;
};

export function RepoList({ openTitle, open, isActive }: Props) {
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
      {entries.map((entry) => (
        <List.Item
          key={entry.fullPath}
          title={entry.title}
          subtitle={entry.subtitle}
          accessories={
            isActive(entry) ? [{ tag: { value: "active" } }] : undefined
          }
          actions={
            <ActionPanel>
              <Action
                title={openTitle}
                onAction={async () => {
                  await closeMainWindow();
                  open(entry);
                }}
              />
              <Action
                title="Open in VS Code"
                shortcut={Keyboard.Shortcut.Common.Open}
                onAction={async () => {
                  await closeMainWindow();
                  run(`code ${shellEscape(entry.fullPath)}`);
                }}
              />
              <Action.CopyToClipboard
                title="Copy Path"
                content={entry.fullPath}
                shortcut={Keyboard.Shortcut.Common.Copy}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
