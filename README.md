# dotfiles

macOS 開発環境を管理する dotfiles です。セットアップスクリプト一発で、シェル・エディタ・Git・AI エージェントの設定を一括で構築できます。

## ディレクトリ構成

```
dotfiles/
├── install.sh        # エントリーポイント
├── scripts/          # セットアップスクリプト群
├── terminal/         # zsh / tmux / starship 設定
├── editors/          # Neovim / VS Code 設定
├── git/              # Git 設定
├── ai-agents/        # Claude / Codex / Gemini 設定
└── docs/             # 補足ドキュメント
```

## セットアップ

```bash
git clone https://github.com/seka/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` は以下を順に実行します：

| スクリプト | 内容 |
| --- | --- |
| `scripts/setup-brew` | Homebrew + Brewfile のパッケージインストール |
| `scripts/setup-login-shell` | zsh をログインシェルに設定 |
| `scripts/macos-defaults` | macOS のシステム設定（Finder, Dock, セキュリティ等） |
| `scripts/setup-pip` | Python 環境（pipx, pynvim）のセットアップ |
| `scripts/setup-ai-agents` | AI エージェントスキルのインストール |

その後、XDG Base Directory に準拠したシンボリックリンクを設定します。

## ツール一覧

- [CLI ツール](docs/tools-cli.md) — シェル・エディタ・Git・インフラ等
- [GUI アプリ](docs/tools-gui.md) — ターミナル・エディタ・ユーティリティ等
- [AI エージェント設定](docs/ai-agents.md) — Claude Code / Codex / Gemini の設定詳細
