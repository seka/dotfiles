# dotfiles

macOSとWindowsの開発環境を管理するdotfilesです。OSごとのエントリーポイントから、パッケージ、エディタ、Git、AIエージェントの設定をまとめて構築します。

## ディレクトリ構成

```text
dotfiles/
├── install.sh         # macOS用エントリーポイント
├── install.ps1        # Windows用エントリーポイント
├── scripts/
│   ├── common/        # 設定配置などの共通処理
│   ├── macos/         # HomebrewとmacOS固有設定
│   └── windows/       # wingetとPowerShell固有設定
├── terminal/          # zsh / tmux / starship設定
├── editors/           # Neovim / VS Code設定
├── git/               # Git設定
├── ai-agents/         # Claude Code / Codex / Gemini CLI設定
└── docs/              # ツールと設定の詳細
```

## セットアップ

### macOS

#### 実行

```bash
git clone https://github.com/seka/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh`は次の処理を実行します。

1. OSパッケージをHomebrewからインストール
2. 言語ランタイムをセットアップ
3. macOSとログインシェルを設定
4. Pythonツールをセットアップ
5. Gitとシェル設定を配置
6. エディタ設定とVS Code拡張をセットアップ
7. AI CLI、AIエージェント設定、スキルをセットアップ

macOSではasdf、rbenv、nodenvを利用し、ターミナル環境はzshを前提とします。

### Windows

#### 前提条件

- Windows 10またはWindows 11
- App Installerに含まれる`winget`
- PowerShell

確認:

```powershell
winget --version
```

#### 実行

PowerShellでdotfilesのディレクトリへ移動して実行します。

```powershell
Set-Location C:\path\to\dotfiles
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

`install.ps1`は次の処理を実行します。

1. OSパッケージをwingetからインストール
2. PowerShell 7を導入し、残りの処理をPowerShell 7で再開
3. vfoxで言語ランタイムをセットアップ
4. PowerShellプロファイルを設定
5. Pythonツールをセットアップ
6. AI CLIをセットアップ
7. AIワークスペースツールをセットアップ
8. 不要な自動起動アプリを無効化
9. Git設定を配置
10. エディタ設定とVS Code拡張をセットアップ
11. AIエージェント設定とスキルをセットアップ

WindowsではPowerShellとWindowsネイティブツールに統一しています。MSYS2、zsh、tmuxはWindowsセットアップの対象外です。Git Bashは共通設定スクリプトを内部実行するために使いますが、通常の開発シェルとして意識する必要はありません。
HerdrはWindows previewのため、通常のパッケージ導入とは分けてセットアップします。

スクリプトは再実行できます。wingetやvfoxで導入済みの項目は再利用され、失敗した項目はログを確認して再試行できます。
Windowsセットアップでは、Docker Desktop、Slack、Microsoft Teams、Dropboxなどの重いGUIアプリはインストール対象に含めつつ、自動起動からは外します。1Passwordは自動起動を維持します。

wingetログ:

```text
.logs/winget-import.log
```

## OS間で共有するもの

- Git設定
- NeovimとVS Code設定
- VS Code拡張一覧
- Claude Code、Codex、Gemini CLI設定
- AIエージェント向けガイドとスキル

パッケージの導入方法、シェル、ランタイム管理、PATH設定はOSごとに分離します。

## ドキュメント

- [CLIツール](docs/tools-cli.md)
- [GUIアプリ](docs/tools-gui.md)
- [AIエージェント設定](docs/ai-agents.md)
