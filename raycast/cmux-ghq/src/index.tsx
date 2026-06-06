import { Action, ActionPanel, List, closeMainWindow } from "@raycast/api";
import { useExec } from "@raycast/utils";
import { spawn } from "node:child_process";
import { join } from "node:path";

const PATH = [
  "/opt/homebrew/bin",
  "/usr/local/bin",
  "/usr/bin",
  process.env.PATH,
].join(":");

function run(command: string) {
  console.log("exec:", command);
  const child = spawn("/bin/zsh", ["-c", command], {
    env: { ...process.env, PATH },
    detached: true,
    stdio: "ignore",
  });
  child.unref();
}

const WORKSPACE_LAYOUT = {
  direction: "horizontal",
  split: 0.4,
  children: [
    {
      direction: "vertical",
      split: 0.6,
      children: [
        {
          pane: {
            surfaces: [
              { type: "terminal", name: "lazygit", command: "lazygit" },
              { type: "terminal", name: "yazi", command: "yazi" },
            ],
          },
        },
        {
          pane: {
            surfaces: [{ type: "terminal", name: "shell" }],
          },
        },
      ],
    },
    {
      direction: "vertical",
      split: 0.5,
      children: [
        {
          pane: {
            surfaces: [
              { type: "terminal", name: "claude", command: "claude", focus: true },
            ],
          },
        },
        {
          pane: {
            surfaces: [
              { type: "terminal", name: "claude", command: "claude", focus: true },
            ],
          },
        },
      ],
    },
  ],
};

function openInCmux(fullPath: string, name: string) {
  const layout = JSON.stringify(WORKSPACE_LAYOUT);
  const cmd = [
    `existing=$(cmux list-workspaces | grep '${name}' | grep -o 'workspace:[0-9]*' | head -1)`,
    `if [ -n "$existing" ]; then`,
    `  cmux select-workspace --workspace "$existing"`,
    `else`,
    `  ws=$(cmux new-workspace --cwd '${fullPath}' --layout '${layout}' --focus true | awk '{print $2}') && cmux rename-workspace --workspace "$ws" '${name}'`,
    `fi`,
    `open -a cmux`,
  ].join("\n");
  run(cmd);
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

  if (rootError || listError) {
    console.error("ghq error:", rootError?.message ?? listError?.message);
  }

  return (
    <List
      isLoading={isLoadingRoot || isLoadingList}
      searchBarPlaceholder="Search repositories..."
    >
      {repos?.map((repo) => {
        const fullPath = ghqRoot ? join(ghqRoot, repo) : repo;
        const parts = repo.split("/");
        const displayName = parts.length >= 3 ? parts.slice(1).join("/") : repo;

        return (
          <List.Item
            key={repo}
            title={displayName}
            subtitle={parts[0]}
            actions={
              <ActionPanel>
                <Action
                  title="Open in cmux"
                  onAction={async () => {
                    await closeMainWindow();
                    openInCmux(fullPath, displayName);
                  }}
                />
                <Action
                  title="Open in VS Code"
                  shortcut={{ modifiers: ["cmd"], key: "o" }}
                  onAction={async () => {
                    await closeMainWindow();
                    run(`code '${fullPath}'`);
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
