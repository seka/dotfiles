# ターミナル設定

## zsh

### セットアップ

#### 1. 依存関係

- **zsh** 5.8+
- **fzf** (ファジーファインダー)
- **starship** (プロンプト)
- **1Password CLI** (シークレット管理)
- **ghq** (リポジトリ管理)
- **tig** (Git UI)

#### 2. 初期化

```bash
# zshプラグインの自動インストール（初回起動時）
exec zsh

# 1Password CLIの認証確認
check-1password-auth

# シークレットの読み込み
load-1password-secrets
```

### ディレクトリ構成

```
terminal/
├── README.md         # このファイル
├── aliases           # エイリアス定義
├── functions         # カスタム関数
├── keybinds          # キーバインド設定
├── zsh-plugins       # Zshプラグイン管理（Zinit）
├── zshenv            # 環境変数設定
├── zshrc             # Zsh基本設定
├── inputrc           # Readline設定
├── starship.toml     # Starshipプロンプト設定
└── tigrc             # Tig設定
```

## Zshプラグイン一覧（Zinit管理）

### 補完・入力支援

- **zsh-users/zsh-completions**: 追加補完定義
- **Aloxaf/fzf-tab**: fzfベースの補完メニュー
- **zsh-users/zsh-syntax-highlighting**: シンタックスハイライト
- **zsh-users/zsh-history-substring-search**: 履歴部分検索

### ナビゲーション・検索

- **mollifier/anyframe**: peco/fzfラッパー
- **mollifier/cd-gitroot**: Gitルートディレクトリに移動
- **b4b4r07/enhancd**: インタラクティブcd
- **wfxr/forgit**: インタラクティブGitコマンド

## エイリアス一覧

### ファイル操作

| エイリアス | コマンド | 説明 |
|-----------|----------|------|
| `ls` | `ls -G` | カラー表示付きls |
| `ll` | `ls -la` | 詳細表示 |
| `la` | `ls -A` | 隠しファイル含む一覧 |

### Git

| エイリアス | コマンド | 説明 |
|-----------|----------|------|
| `gitzip` | `git archive HEAD -o` | Git archiveでZIP作成 |

### ネットワーク・システム

| エイリアス | コマンド | 説明 |
|-----------|----------|------|
| `ip` | `dig +short myip.opendns.com @resolver1.opendns.com` | 外部IPアドレス表示 |
| `ports` | `lsof -i -P -n \| grep LISTEN` | 使用中ポート一覧 |
| `speedtest` | `wget -O /dev/null http://speed.transip.nl/100mb.bin` | 回線速度測定 |

### macOS固有

| エイリアス | コマンド | 説明 |
|-----------|----------|------|
| `flushdns` | `sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder` | DNS キャッシュクリア |
| `showfiles` | `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder` | 隠しファイル表示 |
| `hidefiles` | `defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder` | 隠しファイル非表示 |

### dotfiles管理

| エイリアス | コマンド | 説明 |
|-----------|----------|------|
| `dotfiles` | `cd ~/dotfiles` | dotfilesディレクトリに移動 |
| `reload` | `source ~/.zshenv && source ~/.config/zsh/.zshrc` | Zsh設定リロード |

## カスタム関数

### アーカイブ操作

| 関数 | 引数 | 説明 |
|------|------|------|
| `extract()` | ファイルパス | 各種アーカイブの自動展開 |

### プロセス管理

| 関数 | 引数 | 説明 |
|------|------|------|
| `psgrep()` | 検索文字列 | プロセス検索（ps aux + grep） |

### Git操作

| 関数 | 引数 | 説明 |
|------|------|------|
| `remove-unnecessary-branches()` | なし | マージ済みブランチの削除 |
| `remove-orig-files()` | なし | .origファイルの一括削除 |

### fzf統合

| 関数 | 引数 | 説明 |
|------|------|------|
| `p()` | コマンド | fzfで選択したファイルにコマンド実行 |

### 1Password統合

| 関数 | 引数 | 説明 |
|------|------|------|
| `load-1password-secrets()` | なし | 1Passwordからシークレット読み込み |
| `check-1password-auth()` | なし | 1Password CLI認証状態確認 |

## キーバインド一覧

### 基本編集

| キー | 機能 | 説明 |
|------|------|------|
| `Ctrl+A` | `end-of-line` | 行末に移動 |
| `Ctrl+W` | `backward-word` | 前の単語に移動 |
| `Ctrl+B` | `forward-word` | 次の単語に移動 |
| `Option+←` | `backward-word` | 前の単語に移動 |
| `Option+→` | `forward-word` | 次の単語に移動 |

### fzf統合

| キー | 機能 | 説明 |
|------|------|------|
| `Ctrl+X, C` | `fzf-cdr` | 最近のディレクトリ選択 |
| `Ctrl+X, R` | `fzf-select-history` | コマンド履歴選択 |
| `Ctrl+X, G` | `fzf-ghq` | Gitリポジトリ選択 |
| `Ctrl+X, B` | `fzf-git-branches` | Gitブランチ選択 |

## Readline設定（inputrc）

### 履歴検索

- **履歴検索**: 部分入力 + 上下矢印キーで履歴検索
- **履歴展開**: `!!`, `!$` 等の履歴展開を有効化

### 補完

- **大小文字無視**: 補完時に大文字小文字を区別しない
- **ハイフン/アンダースコア**: `-` と `_` を同等に扱う

### 編集ショートカット

| キー | 機能 | 説明 |
|------|------|------|
| `Ctrl+A` | 行頭に移動 | カーソルを行の先頭に移動 |
| `Ctrl+W` | 単語削除 | カーソル位置から前の単語まで削除 |
| `Ctrl+B` | 前の単語 | 前の単語にジャンプ |

### 表示設定

- **差分表示**: 空白文字の違いを無視
- **行番号**: 表示有効
- **タブ幅**: 2文字

## トラブルシューティング

### Zinit関連

```bash
# プラグインの再インストール
zinit self-update
zinit update --all

# キャッシュクリア
zinit cclear
```

### 1Password CLI

```bash
# 認証状態確認
check-1password-auth

# 再認証
op signin

# シークレット再読み込み
load-1password-secrets
```

### fzf統合が動作しない

```bash
# fzfの設定確認
echo $FZF_DEFAULT_OPTS

# 関数の再読み込み
source ~/dotfiles/terminal/functions
```

### 補完が効かない

```bash
# 補完システムの再初期化
autoload -Uz compinit && compinit

# Zinit補完の再構築
zinit creinstall %HOME/dotfiles/terminal
```
