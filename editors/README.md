# エディタ設定

## Vim

### セットアップ

#### 1. 依存関係

- **Neovim** 0.8+
- **Deno** (denops.vim用)
- **Node.js** (一部LSPサーバー用)
- **Git**
- **ripgrep** (telescope検索用)

#### 2. 初期化

```bash
# Neovim起動（初回はプラグインインストールが実行される）
nvim

# LSPサーバー管理画面
:Mason

# health check
:checkhealth
```

### プラグイン追加

1. `install-plugins.vim` にプラグインを追加
2. `setting-plugins.vim` に設定を追加
3. `:call dein#install()` で インストール

#### LSPサーバーインストール

```vim
" Mason経由で自動インストール（設定済み）
" 対応言語: Lua, TypeScript, Go, Python, Rust, HTML, CSS, JSON
:Mason
```

### ログ確認

```bash
# denopsログ
:DenopsLog

# Neovimログ
nvim --headless -c "messages" -c "qa!"
```

### ディレクトリ構成

```
editors/
└── vim/
    ├── nvim/
    │   ├── init.vim              # メイン設定ファイル
    │   ├── install-plugins.vim   # プラグイン定義
    │   ├── setting-plugins.vim   # プラグイン設定
    │   ├── commands.vim          # カスタムコマンド
    │   └── lua/
    │       └── lsp_config.lua    # LSP・モダンプラグイン設定
    ├── plugins/                  # プラグインファイル（dein.vim管理）
    ├── swaps/                    # スワップファイル保存先
    └── backups/                  # バックアップファイル保存先
```

### プラグイン一覧

- **mason.nvim**: LSPサーバー自動管理
- **nvim-lspconfig**: LSP設定
- **ddc.vim**: 補完エンジン（ddc-source-lspでLSP統合）
- **telescope.nvim**: ファジーファインダー・検索
- **toggleterm.nvim**: ターミナル統合
- **bufferline.nvim**: バッファ管理
- **lualine.nvim**: ステータスライン
- **nvim-lint**: リンティング
- **conform.nvim**: フォーマッティング
- **NERDTree**: ファイルエクスプローラー
- **vim-fugitive**: Git統合
- **vim-surround**: テキストオブジェクト操作
- **easymotion**: 高速移動

### 主要ショートカット一覧

#### 検索・ファイル操作

| プラグイン | キー | 機能 |
|-----------|------|------|
| telescope.nvim | `<Space>tf` | ファイル検索 |
| telescope.nvim | `<Space>tg` | 文字列検索（live grep） |
| telescope.nvim | `<Space>tb` | バッファ一覧 |
| telescope.nvim | `<Space>tr` | 最近使ったファイル |
| telescope.nvim | `<Space>th` | ヘルプ検索 |
| telescope.nvim | `<Space>ts` | LSPシンボル検索 |

#### LSP

| プラグイン | キー | 機能 |
|-----------|------|------|
| nvim-lspconfig | `gd` | 定義ジャンプ |
| nvim-lspconfig | `K` | ホバー情報表示 |
| nvim-lspconfig | `gi` | 実装ジャンプ |
| nvim-lspconfig | `gr` | 参照検索 |
| nvim-lspconfig | `<Space>rn` | リネーム |
| nvim-lspconfig | `<Space>ca` | コードアクション |
| conform.nvim | `<Space>f` | フォーマット |
| nvim-lspconfig | `<Space>e` | エラー詳細表示 |
| nvim-lspconfig | `[d` | 前の診断へ移動 |
| nvim-lspconfig | `]d` | 次の診断へ移動 |
| nvim-lspconfig | `<Space>q` | 診断一覧表示 |

#### バッファ・ウィンドウ管理

| プラグイン | キー | 機能 |
|-----------|------|------|
| bufferline.nvim | `[b` | 前のバッファ |
| bufferline.nvim | `]b` | 次のバッファ |
| bufferline.nvim | `<leader>bp` | バッファをピン留め |
| bufferline.nvim | `<leader>bc` | バッファ選択削除 |
| Vim標準 | `<C-H>` | 左のウィンドウへ移動 |
| Vim標準 | `<C-J>` | 下のウィンドウへ移動 |
| Vim標準 | `<C-K>` | 上のウィンドウへ移動 |
| Vim標準 | `<C-L>` | 右のウィンドウへ移動 |

#### ターミナル

| プラグイン | キー | 機能 |
|-----------|------|------|
| toggleterm.nvim | `<C-t>` | フローティングターミナル切り替え |
| toggleterm.nvim | `<C-t>` （ターミナル内） | ターミナルを閉じる |

#### 補完・スニペット

| プラグイン | キー | 機能 |
|-----------|------|------|
| ddc.vim + neosnippet | `<Tab>` | 次の補完候補 / スニペット展開 |
| ddc.vim | `<S-Tab>` | 前の補完候補 |

#### その他

| プラグイン | キー | 機能 |
|-----------|------|------|
| tagbar | `<F8>` | Tagbar切り替え |
| yanktmp | `sy` | yanktmp: ヤンク |
| yanktmp | `sp` | yanktmp: ペースト（後） |
| yanktmp | `sP` | yanktmp: ペースト（前） |
| denops.vim | `<C-c>` | denops割り込み処理 |

### トラブルシュート

#### LSPサーバーが動作しない

```vim
:checkhealth lsp
:Mason
```

#### denopsエラー

```vim
:DenopsCheck
:DenopsRestart
```

#### プラグインインストールエラー

```vim
:call dein#update()
:call dein#recache_runtimepath()
```

#### 補完が効かない

```vim
" ddc.vimの状態確認
:echo ddc#get_current_sources()
```

## VS Code

### セットアップ

#### 1. 依存関係

- **VS Code** 1.70+
- **Node.js** (一部拡張機能用)
- **Git**

#### 2. 初期化

```bash
# VS Code設定をシンボリックリンクでセットアップ
cd editors/vscode
bash setup.sh
```

### ディレクトリ構成

```
editors/
└── vscode/
    ├── settings.json       # VS Code設定ファイル
    ├── keybindings.json   # キーバインド設定
    ├── extensions.txt     # インストール拡張機能リスト
    └── setup.sh          # セットアップスクリプト
```

### 拡張機能

#### エディタ機能拡張

- **esbenp.prettier-vscode**: コードフォーマッター
- **dbaeumer.vscode-eslint**: JavaScript/TypeScript リンター
- **christian-kohler.path-intellisense**: パス補完

#### 開発支援

- **github.copilot**: AI コード補完
- **github.copilot-chat**: AI チャット
- **eamodio.gitlens**: Git 履歴表示・比較

#### 言語サポート

- **shopify.ruby-lsp**: Ruby 言語サーバー
- **shopify.ruby-extensions-pack**: Ruby 開発パック
- **sorbet.sorbet-vscode-extension**: Sorbet 型チェッカー
- **mathiasfrohlich.kotlin**: Kotlin サポート
- **vscjava.vscode-gradle**: Gradle サポート

#### テーマ・UI

- **github.github-vscode-theme**: GitHub テーマ
- **pkief.material-icon-theme**: マテリアルアイコン
- **vscodevim.vim**: Vim キーバインド

#### インフラ・ツール

- **ms-azuretools.vscode-docker**: Docker サポート
- **ms-vscode-remote.remote-containers**: Dev Containers
- **ms-vscode.makefile-tools**: Makefile サポート
- **bradlc.vscode-tailwindcss**: Tailwind CSS サポート

#### データ・設定ファイル

- **redhat.vscode-yaml**: YAML サポート
- **stylelint.vscode-stylelint**: CSS リンター

#### プロジェクト管理

- **alefragnani.project-manager**: プロジェクト管理
- **yoavbls.pretty-ts-errors**: TypeScript エラー整形

#### キーバインド (keybindings.json)

| キー | 機能 | 詳細 |
|------|------|------|
| `Shift+Enter` | ターミナル行継続 | ターミナルで `\` + 改行を送信 |

### トラブルシューティング

#### Copilotが動作しない

1. GitHub アカウントでログイン: `Cmd+Shift+P` → `GitHub Copilot: Sign In`
2. 拡張機能を再有効化: 拡張機能タブで Copilot を無効化→有効化

#### Ruby LSPが動作しない

```bash
# Gemの確認とインストール
gem install ruby-lsp sorbet-runtime
# VS Code再起動
```
