# CLIツール

## 共通

macOSではHomebrew、Windowsではwingetを使い、可能な範囲で同じCLIを導入します。

| 分類 | ツール |
| --- | --- |
| Git | Git、Git LFS、GitHub CLI、ghq、lazygit、tig |
| エディタ | Neovim、VS Code CLI |
| 検索・表示 | ripgrep、fd、bat、eza、fzf |
| データ処理 | jq、yq、HTTPie |
| 開発支援 | CMake、ShellCheck、Universal Ctags、mkcert、codespell、uv |
| クラウド | Docker、AWS CLI |
| AI | Claude Code、Codex CLI、Gemini CLI、Herdr |

パッケージ名や提供状況の違いにより、一部のツールは片方のOSだけに導入されます。

## macOS

パッケージ定義は`scripts/macos/Brewfile`にあります。

### ランタイム管理

| ツール | 用途 |
| --- | --- |
| asdf | 複数言語のバージョン管理 |
| nodenv | Node.jsのバージョン管理 |
| rbenv / ruby-build | Rubyのバージョン管理 |
| Homebrew | Go、OpenJDK、Denoなどの導入 |

### シェル

zshをログインシェルとして使用し、zplug、Starship、fzf、tmux、tigを導入します。設定は`terminal/`からシンボリックリンクされます。

### macOS固有

- Xcode管理: xcodes
- Swift: Mint
- BSDコマンド補完: coreutils、findutils、gnu-sed、binutils
- CI: CircleCI CLI、Bitrise CLI
- ネットワーク: ngrep、lftp
- MongoDB Database Tools

## Windows

パッケージ定義は`scripts/windows/winget.json`にあります。通常の操作はPowerShellで行います。

### ランタイム管理

[vfox](https://vfox.dev)で次のWindowsネイティブランタイムを一元管理します。

| プラグイン | ランタイム |
| --- | --- |
| `nodejs` | Node.js |
| `python` | Python |
| `java` | Java |
| `golang` | Go |
| `ruby` | Ruby |

初期セットアップでは、それぞれ`latest`をインストールしてグローバル既定値に設定します。プロジェクトでは`.vfox.toml`に正確なバージョンを指定することを推奨します。

PowerShellプロファイルには次の初期化が自動追加されます。

```powershell
Invoke-Expression "$(vfox activate pwsh)"
```

### Windows固有

- PowerShell 7
- Windows Terminal
- winget
- vfox
- uv
- gsudo
- 7-Zip
- Docker Desktop
- Herdr Windows preview

WindowsではMSYS2、zsh、tmux、Unix版asdf/rbenv/nodenvを使用しません。設定スクリプトの内部処理に限り、Git for Windows付属のbashを使用します。

### PythonとNode.jsのグローバルツール

| 経路 | ツール |
| --- | --- |
| pipx | pynvim、codespell |
| npm | Gemini CLI |
| winget | uv |

Claude CodeとCodex CLIはwingetからWindowsネイティブ版を導入します。

### AIワークスペース

HerdrはWindows previewのため、`scripts/windows/setup-ai-workspace.ps1`で分離して導入します。失敗しても通常のWindowsセットアップは継続します。
