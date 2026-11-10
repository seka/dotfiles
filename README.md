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
├── ai-agents/         # Claude Code / Codex / Gemini CLI / Antigravity CLI設定
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
3. 開発データの保存先をDドライブへ設定
4. Docker Desktop向けにWSL2基盤をセットアップ
5. vfoxで言語ランタイムをセットアップ
6. PowerShellプロファイルを設定
7. Pythonツールをセットアップ
8. AI CLIをセットアップ
9. AIワークスペースツールをセットアップ
10. Explorerの表示設定をセットアップ
11. 不要な自動起動アプリを無効化
12. Git設定を配置
13. エディタ設定とVS Code拡張をセットアップ
14. AIエージェント設定とスキルをセットアップ

WindowsではPowerShellとWindowsネイティブツールに統一しています。MSYS2、zsh、tmuxはWindowsセットアップの対象外です。Git Bashは共通設定スクリプトを内部実行するために使いますが、通常の開発シェルとして意識する必要はありません。
HerdrはWindows previewのため、通常のパッケージ導入とは分けてセットアップします。
Explorerでは隠しファイルと拡張子を表示するように設定します。
Docker Desktopの実行にはWSL2 backendの基盤が必要なため、WindowsのWSL機能とVirtual Machine Platformを有効化します。Ubuntuなどのユーザー向けLinux distroは自動インストールしません。

スクリプトは再実行できます。wingetやvfoxで導入済みの項目は再利用され、失敗した項目はログを確認して再試行できます。
Windowsセットアップでは、Docker Desktop、Slack、Microsoft Teamsなどの重いGUIアプリはインストール対象に含めつつ、自動起動からは外します。1Passwordは自動起動を維持します。

Windowsではコマンド本体をwingetの標準インストール先に残し、容量が増えやすい開発データをDドライブへ配置します。`scripts\windows\setup-storage.ps1`は再実行可能で、既存ディレクトリを維持したまま次の保存先を設定します。

```text
D:\dev\ghq       # ghqリポジトリ
D:\dev\go        # GOPATH
D:\dev\vfox      # vfox SDK実体
D:\dev\node-global # npmグローバルパッケージ
D:\dev\rust      # Cargo/Rustup
D:\caches        # Cargo/npm/pip/uvキャッシュ
D:\Hyper-V       # Hyper-V VM
D:\containers\docker # Docker Desktopデータ
D:\build         # ビルド成果物
D:\iso           # ISOイメージ
```

Dドライブ以外を使う場合は、実行前に保存先ドライブを指定します。

```powershell
$env:DOTFILES_DATA_DRIVE = "E:\"
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

このセットアップは保存先と標準ディレクトリを構成しますが、既存のGitリポジトリ、Hyper-V VM、Docker仮想ディスク、Cargo/Rustupデータは自動移動しません。各製品の正規手順で移行し、動作確認後にCドライブ側を削除してください。

wingetログ:

```text
.logs/winget-import.log
```

## OS間で共有するもの

- Git設定
- NeovimとVS Code設定
- VS Code拡張一覧
- Claude Code、Codex、Gemini CLI、Antigravity CLI設定
- AIエージェント向けガイドとスキル

パッケージの導入方法、シェル、ランタイム管理、PATH設定はOSごとに分離します。

## ドキュメント

- [CLIツール](docs/tools-cli.md)
- [GUIアプリ](docs/tools-gui.md)
- [AIエージェント設定](docs/ai-agents.md)
