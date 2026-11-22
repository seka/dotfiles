# ターミナル設定

## zsh

### セットアップ

#### 1. 依存関係

- **zsh** 5.8+
- **fzf** (ファジーファインダー)
- **starship** (プロンプト)
- **direnv** (ディレクトリごとの環境変数管理)
- **1Password CLI** (シークレット管理)
- **ghq** (リポジトリ管理)
- **tig** (Git UI)

#### 2. 初期化

```bash
# zshプラグインの自動インストール（初回起動時）
exec zsh

# 1Password CLIの認証確認
1password-check-auth
```

### direnv

macOSではHomebrewでdirenvを導入し、`terminal/zshrc`の末尾でzsh hookを有効にします。設定の反映にはターミナルを開き直すか、`exec zsh`を実行します。

direnvはプロジェクトの`.envrc`を読み込み、ディレクトリを離れると環境変数を元に戻します。`.env`は標準では自動読み込みしません。既存の`.env`をシェルからも使う場合は、プロジェクトのルートに次の内容の`.envrc`を作成します。

```bash
dotenv .env
```

内容を確認したうえで、そのディレクトリで読み込みを許可します。`.envrc`を変更した場合も再度許可が必要です。

```bash
direnv allow .
```

`.envrc`はシェルコードとして実行されるため、信頼できる内容だけを許可します。秘密情報は`.envrc`に直接記載せず、`.env`に置いてGitの追跡対象から除外してください。キャッシュなどを保存する`.direnv/`も各プロジェクトの`.gitignore`に追加します。

Next.jsなどがすでに設定を読み込んでいる場合、direnvの利用は任意です。複数の仕組みで同じ変数を設定すると値の優先順位に影響するため、シェルで共有したい変数に絞って使います。

公式資料: [zsh連携](https://direnv.net/docs/hook.html)、[使い方](https://direnv.net/)。

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
| `speedtest` | `networkQuality` | 回線速度測定（macOS 標準コマンド） |

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
| `git-gtr-cd` | ブランチ名（省略可） | worktree に移動。省略時は fzf で選択 |
| `git-remove-orig-files` | なし | カレントディレクトリ以下の `*.orig` ファイルを一括削除 |

### 1Password統合

| 関数 | 引数 | 説明 |
|------|------|------|
| `1password-check-auth()` | なし | 1Password CLI認証状態確認 |

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
| `Ctrl+X, W` | `fzf-git-worktrees` | Git worktree 選択 |

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
1password-check-auth

# 再認証
op signin
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

## tmux

macOSでは`~/.tmux.conf`から`terminal/tmux.conf`を読み込みます。prefixキーは`Ctrl+t`です。

### 作業環境の保存・復元

`scripts/macos/setup-tmux`がtmux設定を配置し、[TPM](https://github.com/tmux-plugins/tpm)を取得します。TPMは`terminal/tmux.conf`の`@plugin`一覧から次のプラグインを`~/.tmux/plugins/`へ導入します。再実行時は既存のGit checkoutを保持します。`install.sh`からも実行されます。Windowsセットアップでは導入しません。

- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect): セッション、ウィンドウ、ペイン配置、作業ディレクトリを保存・復元
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum): 15分ごとの自動保存とtmuxサーバー起動時の自動復元

既存環境へセットアップする場合:

```bash
bash scripts/macos/setup-tmux
```

起動中のtmuxへ設定を反映する場合:

```bash
tmux source-file ~/.tmux.conf
```

| 操作 | キー |
| --- | --- |
| 今すぐ保存 | `Ctrl+t` → `Ctrl+s` |
| 最後の保存状態を復元 | `Ctrl+t` → `Ctrl+r` |

再起動前に最新状態を残したい場合は、手動で保存してください。保存先は既存の`~/.tmux/resurrect/`があればそのディレクトリ、それ以外は`${XDG_DATA_HOME:-~/.local/share}/tmux/resurrect/`です。自動復元はtmuxサーバーの起動時だけ実行され、設定の再読み込みや既存サーバーへの接続では実行されません。

Continuumは複数のtmuxサーバーがある場合、保存データの競合を防ぐため自動保存・復元を抑制することがあります。通常の単一サーバー内で複数セッションを使う構成を想定しています。

Continuumの定期保存にはステータスバーが必要です。`status-right`に処理を追加するため、テーマなどを追加する場合もContinuumを最後に読み込みます。

復元はプロセスの内部状態の再開ではありません。一部のプログラムはResurrectの既定設定に従って再起動されますが、AIの会話や実行途中の処理、開発サーバーの状態は復元しません。Neovimの編集セッション復元とペインの表示内容の保存は、追加設定が必要で、この構成では有効にしていません。

### プラグイン管理

プラグインは`terminal/tmux.conf`の`@plugin`一覧で管理し、セットアップ時に不足分を導入します。Continuumを一覧の最後に置き、TPM初期化後に追加・更新のショートカットを解除します。

セットアップスクリプトは既存プラグインを自動更新しません。TPMによる更新の自動検知・通知もありません。
