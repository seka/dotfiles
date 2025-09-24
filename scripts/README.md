# セットアップスクリプト

## 概要

新しい環境での開発環境セットアップを自動化するスクリプト群です。
macOSの設定、Homebrew管理、Pythonツールの設定を含みます。

## セットアップ

### 1. 依存関係

- **macOS** 12.0+ (Monterey以降)
- **インターネット接続** (Homebrew、パッケージダウンロード用)
- **管理者権限** (一部設定変更用)

### 2. 使用方法

```bash
# dotfilesディレクトリに移動
cd ~/dotfiles

# 実行権限の確認・付与
chmod +x scripts/*

# 全体セットアップ（推奨）
./install.sh

# 個別実行も可能
./scripts/setup-brew          # Homebrew + パッケージ
./scripts/macos-defaults      # macOS設定
./scripts/setup-login-shell   # ログインシェル設定
./scripts/setup-pip           # Python環境
```

## ディレクトリ構成

```
scripts/
├── README.md          # このファイル
├── Brewfile           # Homebrew パッケージ定義
├── setup-brew*        # Homebrew + パッケージインストール
├── macos-defaults*    # macOS システム設定
├── setup-login-shell* # ログインシェル設定（zsh）
└── setup-pip*         # Python環境設定
```

## スクリプト詳細

### setup-brew

**目的**: Homebrewとパッケージの自動インストール

#### 機能

- **Homebrew自動インストール** - 未インストール時のみ
- **パッケージ一括インストール** - Brewfileから読み込み
- **Java環境設定** - OpenJDK設定（インストール時）
- **クリーンアップ** - 古いパッケージの削除

#### 実行内容

1. Homebrewの存在確認・インストール
2. Homebrewのアップデート
3. Brewfileからパッケージインストール
4. Java環境の設定
5. 不要パッケージのクリーンアップ

```bash
# 単独実行
./scripts/setup-brew

# ログ確認
brew list --formula    # インストール済みformula
brew list --cask       # インストール済みcask
```
### setup-pip

**目的**: Python開発環境の設定

#### 機能
- **pipx自動インストール** - Homebrew経由
- **pynvim インストール** - Neovim Python支援
- **PATH設定** - pipxコマンドパス確保

```bash
# インストール確認
pipx list

# pynvim動作確認
python -c "import pynvim; print('OK')"
```

## Brewfile

### パッケージ管理

#### プログラミング言語
```ruby
# 言語バージョン管理
brew "asdf"              # 多言語バージョン管理
brew "rbenv"             # Ruby
brew "nodenv"            # Node.js
brew "go"                # Go
brew "openjdk"           # Java
```

#### シェル・ターミナルツール
```ruby
brew "zsh"               # シェル
brew "fzf"               # ファジーファインダー
brew "starship"          # プロンプト
brew "tmux"              # ターミナル多重化
```

#### モダン代替ツール
```ruby
brew "bat"               # cat代替
brew "eza"               # ls代替
brew "fd"                # find代替
brew "ripgrep"           # grep代替
brew "sd"                # sed代替
brew "htop"              # top代替
```

#### Git関連
```ruby
brew "git"               # Git本体
brew "gh"                # GitHub CLI
brew "ghq"               # リポジトリ管理
brew "gitmoji-cli"       # 絵文字コミット
brew "lazygit"           # Git GUI
```

#### 開発ツール
```ruby
brew "neovim"            # エディタ
brew "docker"            # コンテナ
brew "jq"                # JSON処理
brew "shellcheck"        # シェルスクリプト検査
```

### GUI アプリケーション（Cask）

#### 開発ツール
```ruby
cask "visual-studio-code"      # エディタ
cask "android-studio"          # Android開発
cask "dash"                    # API ドキュメント
cask "dbeaver-community"       # データベース管理
```

#### システムユーティリティ
```ruby
cask "rectangle"               # ウィンドウ管理
cask "clipy"                   # クリップボード拡張
cask "the-unarchiver"          # アーカイブ展開
cask "1password"               # パスワード管理
```

### Brewfile操作コマンド

```bash
# パッケージインストール
brew bundle --file=~/dotfiles/scripts/Brewfile

# インストール状況確認
brew bundle check --file=~/dotfiles/scripts/Brewfile

# Brewfile生成（現在の環境から）
brew bundle dump --file=~/dotfiles/scripts/Brewfile --force

# 特定のパッケージのみインストール
brew bundle --file=~/dotfiles/scripts/Brewfile --no-upgrade

# クリーンアップ（Brewfileにないパッケージ削除）
brew bundle cleanup --file=~/dotfiles/scripts/Brewfile
```

## インストールツール コマンド一覧

### モダン代替ツール

| ツール | 代替対象 | 基本コマンド | 説明 |
|--------|----------|--------------|------|
| **bat** | cat | `bat file.txt` | シンタックスハイライト付きファイル表示 |
|  |  | `bat -A file.txt` | 制御文字も表示 |
|  |  | `bat --style=numbers file.txt` | 行番号付き表示 |
| **eza** | ls | `eza` | カラー表示のファイル一覧 |
|  |  | `eza -la` | 詳細表示（隠しファイル含む） |
|  |  | `eza --tree` | ツリー表示 |
|  |  | `eza -la --git` | Git情報付き表示 |
| **fd** | find | `fd pattern` | パターンでファイル検索 |
|  |  | `fd -e js` | 拡張子指定検索（.jsファイル） |
|  |  | `fd -t f pattern` | ファイルのみ検索 |
|  |  | `fd -H pattern` | 隠しファイル含む検索 |
| **ripgrep** | grep | `rg pattern` | 高速テキスト検索 |
|  |  | `rg -i pattern` | 大文字小文字無視 |
|  |  | `rg -n pattern` | 行番号表示 |
|  |  | `rg -t js pattern` | ファイルタイプ指定 |
| **sd** | sed | `sd 'old' 'new' file.txt` | 直感的なテキスト置換 |
|  |  | `sd '\d+' 'NUMBER'` | 正規表現での置換 |
|  |  | `fd -e txt \| xargs sd 'old' 'new'` | 複数ファイル一括置換 |
| **htop** | top | `htop` | インタラクティブプロセス監視 |
|  |  | `htop -u username` | 特定ユーザーのプロセス表示 |

### Git関連ツール

| ツール | 基本コマンド | 説明 |
|--------|--------------|------|
| **gh** | `gh repo list` | リポジトリ一覧表示 |
|  | `gh pr create` | プルリクエスト作成 |
|  | `gh pr list` | プルリクエスト一覧 |
|  | `gh issue create` | Issue作成 |
|  | `gh auth login` | GitHub認証 |
| **ghq** | `ghq list` | 管理中リポジトリ一覧 |
|  | `ghq get <URL>` | リポジトリクローン |
|  | `ghq look <repo>` | リポジトリディレクトリに移動 |
|  | `ghq root` | 管理ディレクトリ表示 |
| **gitmoji-cli** | `gitmoji -c` | 絵文字付きコミット作成 |
|  | `gitmoji -l` | 絵文字一覧表示 |
|  | `gitmoji -s` | 検索モード |
|  | `gitmoji --init` | プロジェクト初期化 |
| **lazygit** | `lazygit` | Git GUI起動 |
|  | `lazygit -p <path>` | 指定パスでGit GUI起動 |

### ターミナル強化ツール

| ツール | 基本コマンド | 説明 |
|--------|--------------|------|
| **fzf** | `history \| fzf` | コマンド履歴をファジー検索 |
|  | `find . \| fzf` | ファイルをファジー検索 |
|  | `git branch \| fzf` | ブランチをファジー選択 |
|  | `ps aux \| fzf` | プロセスをファジー選択 |
| **tig** | `tig` | Git ログビューア起動 |
|  | `tig blame <file>` | ファイルのblame表示 |
|  | `tig status` | Git status表示 |
|  | `tig <branch>` | 特定ブランチのログ表示 |
| **tmux** | `tmux new-session` | 新セッション作成 |
|  | `tmux attach` | セッションにアタッチ |
|  | `tmux list-sessions` | セッション一覧 |
|  | `tmux kill-session` | セッション終了 |

### その他のユーティリティ

| ツール | 基本コマンド | 説明 |
|--------|--------------|------|
| **tree** | `tree` | ディレクトリツリー表示 |
|  | `tree -a` | 隠しファイル含む |
|  | `tree -L 2` | 深度2まで表示 |
|  | `tree -I node_modules` | 指定ディレクトリ除外 |
| **jq** | `echo '{"name":"value"}' \| jq` | JSON整形表示 |
|  | `cat data.json \| jq '.key'` | 特定キーの値取得 |
|  | `curl -s api.com \| jq` | API レスポンス整形 |
| **httpie** | `http get httpbin.org/get` | HTTP GETリクエスト |
|  | `http post httpbin.org/post name=value` | POST リクエスト |
|  | `http --json POST api.com < data.json` | JSON送信 |

### プロンプト・シェル

| ツール | 設定・コマンド | 説明 |
|--------|----------------|------|
| **starship** | `starship config` | 設定ファイル表示 |
|  | `starship preset` | プリセット一覧 |
|  | `starship explain` | プロンプト要素説明 |
| **zsh-completions** | `compinit` | 補完システム初期化 |
|  | 自動適用 | 追加補完定義を提供 |
