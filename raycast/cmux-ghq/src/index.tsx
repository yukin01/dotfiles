import { Action, ActionPanel, List, closeMainWindow, showToast, Toast } from "@raycast/api";
import { useExec } from "@raycast/utils";
import { exec } from "node:child_process";
import { join } from "node:path";

const PATH = ["/opt/homebrew/bin", "/usr/local/bin", "/usr/bin", process.env.PATH].join(":");
const execOptions = { env: { ...process.env, PATH }, shell: "/bin/zsh" as const };

function run(command: string) {
  console.log("exec:", command);
  exec(command, execOptions, (error, stdout, stderr) => {
    if (error) {
      console.error("exec error:", error.message, stderr);
      showToast({ style: Toast.Style.Failure, title: "Error", message: error.message });
    } else if (stdout.trim()) {
      console.log("stdout:", stdout.trim());
    }
  });
}

function openInCmux(fullPath: string, name: string) {
  const cmd = [
    `existing=$(cmux list-workspaces | grep '${name}' | head -1 | awk '{print $2}')`,
    `if [ -n "$existing" ]; then`,
    `  cmux select-workspace --workspace "$existing"`,
    `else`,
    `  ws=$(cmux new-workspace --cwd '${fullPath}' --command cmux-dev | awk '{print $2}') && cmux rename-workspace --workspace "$ws" '${name}'`,
    `fi`,
  ].join("\n");
  run(cmd);
}

export default function Command() {
  const { data: ghqRoot, isLoading: isLoadingRoot, error: rootError } = useExec("ghq", ["root"], {
    env: { PATH },
    parseOutput: ({ stdout }) => stdout.trim(),
  });

  const { data: repos, isLoading: isLoadingList, error: listError } = useExec("ghq", ["list"], {
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
    <List isLoading={isLoadingRoot || isLoadingList} searchBarPlaceholder="Search repositories...">
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
                <Action.CopyToClipboard title="Copy Path" content={fullPath} shortcut={{ modifiers: ["cmd", "shift"], key: "c" }} />
              </ActionPanel>
            }
          />
        );
      })}
    </List>
  );
}
