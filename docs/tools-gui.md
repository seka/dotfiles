# GUIアプリ

## 共通

| 分類 | アプリ |
| --- | --- |
| 開発 | Visual Studio Code、Android Studio、DBeaver、Docker Desktop |
| コミュニケーション | Slack、Microsoft Teams |
| デザイン | Figma |
| ストレージ | Dropbox |
| セキュリティ | 1Password |
| ノート・読書 | Obsidian、Kindle |

## macOS

`scripts/macos/Brewfile`からHomebrew Caskで導入します。

| 分類 | アプリ |
| --- | --- |
| ターミナル | Ghostty |
| AI | ChatGPT、Claude、Codex App、ChatGPT Atlas |
| Git | Git Credential Manager、Gitify |
| 生産性 | Dash、Maccy、Rectangle |
| システム | AppCleaner、The Unarchiver、Backdrop |
| フォント | Source Han Code JP |

## Windows

`scripts/windows/winget.json`からwingetで導入します。

| 分類 | アプリ |
| --- | --- |
| ターミナル | Windows Terminal |
| 開発 | Visual Studio Code、Android Studio、DBeaver、Docker Desktop |
| ランチャー | ueli |
| 生産性 | 1Password、Obsidian、7-Zip |
| コミュニケーション | Slack、Microsoft Teams |
| デザイン | Figma |
| ストレージ | Dropbox |
| 読書 | Kindle |

AI CLIはGUIアプリとは分け、Claude CodeとCodex CLIをwinget、Gemini CLIをvfox管理のnpmから導入します。
