# エディタ設定

## Vim

### セットアップ

#### 1. 依存関係

- **Neovim** 0.12+
- **tree-sitter CLI** 0.26.1+（macOS: `brew install tree-sitter-cli`。npm版は使用しない）
- **Cコンパイラー**、**tar**、**curl**（パーサーのビルド・取得用）
- **Deno** 2.3.0+ (denops.vim / dpp.vim用)
- **Node.js** (一部LSPサーバー用)
- **Git**
- **ripgrep** (telescope検索用)

#### 2. 初期化

```bash
# Neovim起動（初回は dpp の状態生成とプラグイン取得が実行される）
nvim

# LSPサーバー管理画面
:Mason

# health check
:checkhealth
```

初回は取得完了のメッセージを待って Neovim を再起動してください。
状態を読み込める次回起動から、LSP・補完・各プラグイン設定が有効になります。

### プラグイン追加

1. `dpp.ts` の `repositories` にプラグインを追加
2. `setting-plugins.vim` に設定を追加
3. `:DppInstall` で状態を再生成して不足プラグインを取得し、完了後に再起動

#### LSPサーバーインストール

```vim
" Mason経由で自動インストール（設定済み）
" 対応言語: Lua, TypeScript, Go, Python, Rust, HTML, CSS, JSON
:Mason
```

### プラグイン構成

```
editors/
└── vim/
    ├── nvim/
    │   ├── init.vim              # メイン設定ファイル
    │   ├── install-plugins.vim   # dpp の初回構築・状態読み込み
    │   ├── dpp.ts                # プラグイン一覧・固定リビジョン
    │   ├── setting-plugins.vim   # プラグイン設定
    │   ├── commands.vim          # カスタムコマンド
    │   └── lua/
    │       └── lsp_config.lua    # LSP・モダンプラグイン設定
    ├── plugins/
    │   ├── repos/github.com/     # プラグインの取得先（所有者／リポジトリ名）
    │   └── nvim/                 # dpp の状態ファイル・生成した runtimepath
    ├── swaps/                    # スワップファイル保存先
    └── backups/                  # バックアップファイル保存先
```

`init.vim` が `install-plugins.vim` を読み込み、dpp の状態からプラグインの
runtimepath を設定します。`dpp.ts` は取得先と固定リビジョンを定義します。
プラグインを読み込める状態では、`setting-plugins.vim` と `lua/lsp_config.lua` で
各プラグインと LSP を設定します。

### Markdown プレビュー

[Leaf](https://github.com/rivolink/leaf) を使い、現在のファイルを右側の分割ウィンドウでプレビューできます。

```bash
brew install leaf-markdown-viewer
```

Markdown ファイルを保存してから、次のコマンドを実行します。

```vim
:Leaf
```

- `:w` で保存するたびにプレビューが更新されます。未保存の編集内容は反映されません。
- ファイル名に空白が含まれていても利用できます。
- プレビュー内の `q` で Leaf を終了します。
- 設定追加後、起動中の Neovim には `:runtime commands.vim` でコマンドを読み込めます。

### ログ確認

```bash
# denopsログ
:DenopsLog

# Neovimログ
nvim --headless -c "messages" -c "qa!"
```

### プラグイン一覧

#### dpp.vim

プラグインマネージャーです。`dpp-ext-installer` と `dpp-protocol-git` を組み合わせ、
Git リポジトリからプラグインを取得・更新します。

`DppInstall` は不足分の取得、`DppUpdate [プラグイン名 ...]` は更新、`DppCache` は状態だけの再生成です。
一覧・固定リビジョンを変更した場合は `DppInstall`、取得を伴わない状態再生成には `DppCache` を使い、完了後に再起動してください。

#### denops.vim

Deno で動く dpp・ddc と Neovim を接続する共通基盤です。

通常は denops の個別サーバーを使い、共有サーバーへの接続は必須にしません。
設定はプラグイン読み込み前に `install-plugins.vim` で行います。
dpp のヘルプ結合はシンボリックリンクを作るため、Deno の書き込み権限はパスで制限できません。
外部コマンド実行は Git と Deno に限定しています。

#### 補完・検索

- **ddc.vim**: 補完エンジン。`ddc-source-lsp` で LSP の候補、`ddc-source-around` で周辺テキストの候補を取得し、pum のポップアップに表示します。
- **neosnippet**: スニペットの展開とプレースホルダー間の移動。定義は `neosnippet-snippets` を使用します。
- **telescope.nvim**: ファイル・文字列・バッファなどの検索。`plenary.nvim` を必須依存として使用します。

#### LSP・診断・整形

- **mason.nvim / mason-lspconfig.nvim**: `ensure_installed` で言語サーバーを取得します。
- **nvim-lspconfig**: 言語サーバーの定義を提供します。`vim.lsp.config()` で設定し、`vim.lsp.enable()` で有効化します。Go の定義移動は gopls / LSP の `gd` を使用します。
- **Neovim 標準診断**: 移動は `vim.diagnostic.jump()`、サインは `vim.diagnostic.config()` で設定します。
- **nvim-lint**: ファイル保存後に言語別のリンターを実行します。
- **conform.nvim**: 保存時の整形。`lsp_format = "fallback"` で、外部フォーマッターを利用できない場合に LSP を使用します。

#### 表示・編集支援

- **toggleterm.nvim**: フローティングターミナル。
- **bufferline.nvim**: バッファ一覧の表示と切り替え。
- **lualine.nvim**: ステータスライン。
- **NERDTree**: ファイルツリー。タブ間のツリー同期は提供しません。
- **indent-blankline.nvim**: v3.10.1 を使用してインデントガイドを表示します。scope 表示は無効です。
- **vim-visual-multi**: v0.5.8 を使用した複数カーソル編集。`Ctrl-N` で単語・次の一致を選択し、`Tab` でカーソル／領域モードを切り替えます。詳細は `:help visual-multi`。
- **vim-fugitive**: Git 操作。
- **vim-surround**: 囲み文字の追加・変更・削除。
- **easymotion**: 画面内の高速移動。

#### nvim-treesitter

nvim-treesitter は `main` ブランチのコミット
`19bdfc04f40ed2ccb3340591d125f759b0406875` に固定しています。
現行版には正式リリースタグがないための例外で、CLI は正式リリース版を利用します。

既存環境では Neovim 内で対象プラグインを更新し、キャッシュを再構築して再起動します。

```vim
:DppUpdate nvim-treesitter
" 更新後の状態再生成は自動。完了メッセージを待って再起動
```

プラグインの固定コミットを今後更新した場合は、再起動後に `:TSUpdate` で
導入済みパーサーも更新してください。
現状はパーサーの自動インストールやハイライトの自動有効化は設定していません。
必要な言語を `:TSInstall lua` などで導入し、ハイライトは
`vim.treesitter.start()` で有効にします。

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

denops の Deno キャッシュは `stdpath('cache') . '/denops/deno'` に保存します。
`Failed to transform` / `Requires write access` が出る場合は、設定を反映するため
Neovim を再起動してください。初回は専用キャッシュへの依存取得が発生します。


```vim
:DenopsCheck
:DenopsRestart
```

#### プラグインインストールエラー

```vim
:DppInstall
" 状態だけ再生成する場合
:DppCache
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

- **ms-azuretools.vscode-containers**: Container Tools（Docker / Podman サポート）
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
