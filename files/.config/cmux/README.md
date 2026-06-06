# cmux config

## Files

- `cmux.json` — primary config (commands, workspace layouts)
- `sidebars/*.swift` — custom sidebar definitions (SwiftUI 風 DSL)

## Custom sidebars (beta) の有効化

cmux.json では指定できず、NSUserDefaults に直接書き込む必要がある:

```bash
defaults write com.cmuxterm.app customSidebars.beta.enabled -bool true
```

設定後 cmux を完全再起動 (Cmd+Q → 起動) し、サイドバートグルボタン (Cmd+B のボタン) を右クリックして sidebar を選択する。

> ⚠️ **これは cmux v0.64.13 時点の beta 機能。** UI に toggle が露出していないため
> defaults 直書きで有効化している。将来のリリースで以下が変わる可能性あり:
>
> - キー名 (`customSidebars.beta.enabled`)
> - Settings UI への toggle 追加 (そうなれば defaults 直書き不要)
> - cmux.json への移行 (現状の `additionalProperties: false` 制約が緩む可能性)
>
> 最新情報は以下を確認:
>
> - beta key 定義: <https://github.com/manaflow-ai/cmux/blob/main/Packages/CmuxSettings/Sources/CmuxSettings/Keys/BetaFeaturesCatalogSection.swift>
> - sidebar 作成ガイド: <https://github.com/manaflow-ai/cmux/blob/main/docs/custom-sidebars.md>
> - cmux.json schema: <https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json>
