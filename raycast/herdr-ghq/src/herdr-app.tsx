import { useExec } from "@raycast/utils";
import { homedir } from "node:os";
import { join } from "node:path";
import { PATH, RepoList, run, shellEscape } from "./repo-list";

// focus-or-create + レイアウト構築 + Herdr の前面化は herdr-app-open に委譲
const HERDR_APP_OPEN = join(homedir(), "dotfiles/bin/herdr-app-open");

// herdr-app-open と同じく space の作成時フォルダで開いているかを判定する。
// useExec の結果は JSON でキャッシュされ Set は復元されないため配列で返す
function parseSpaceFolders(stdout: string): string[] {
  try {
    const data = JSON.parse(stdout);
    return (data.spaces ?? [])
      .filter((s: { machine: string | null }) => s.machine === null)
      .map((s: { folder: string }) => s.folder);
  } catch {
    return [];
  }
}

export default function Command() {
  // ウィンドウが無いと失敗するが、その場合は active 表示が出ないだけ
  const { data: openFolders } = useExec("herdr-app", ["ls"], {
    env: { PATH },
    parseOutput: ({ stdout }) => parseSpaceFolders(stdout),
  });
  // 旧版 (Set を返していた) のキャッシュが {} として復元されることがあるため配列か確かめる
  const openFolderList = Array.isArray(openFolders) ? openFolders : [];

  return (
    <RepoList
      openTitle="Open in Herdr App"
      open={({ fullPath }) =>
        run(`${shellEscape(HERDR_APP_OPEN)} ${shellEscape(fullPath)}`)
      }
      isActive={({ fullPath }) => openFolderList.includes(fullPath)}
    />
  );
}
