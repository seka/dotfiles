# AI エージェント設定

`ai-agents/` ディレクトリに各エージェントの設定ファイルをまとめています。

## セットアップ

### macOS

Claude Code、Codex CLI、Gemini CLI、Antigravity CLIは`scripts/macos/Brewfile`から導入します。`install.sh`が設定ファイルのシンボリックリンクとスキルのセットアップまで実行します。

### Windows

Claude Code、Codex CLI、Antigravity CLIはwingetから導入します。Antigravity CLIのパッケージIDは `Google.AntigravityCLI` です。Gemini CLIはvfoxで管理するNode.jsのnpmから導入します。`install.ps1`が設定ファイルのコピーとスキルのセットアップまで実行します。

設定ファイルはOS間で共有します。Codexの`config.toml`のみテンプレートをレンダリングし、OS固有の値を切り替えます。

## Claude Code

設定ファイル: `ai-agents/claude/settings.json`

| 項目 | 値 | 説明 |
| --- | --- | --- |
| `defaultMode` | `plan` | 実行前に計画を立てるモードをデフォルトに |
| `advisorModel` | `sonnet` | アドバイザーモデルに Sonnet を使用 |
| `agentPushNotifEnabled` | `true` | エージェント完了時にプッシュ通知を送信 |

**パーミッション設定:**

| 種別 | 対象 |
| --- | --- |
| 許可 | `agy -p` |
| 拒否 | `curl`, `wget`, `sudo`, `.env.*` の読み取り |

共通エージェントガイドは `ai-agents/AGENTS.md` を参照。

**プラグイン:**

| プラグイン | 説明 |
| --- | --- |
| [crit](https://crit.md) | ブラウザ UI でのライン単位コードレビューとフィードバック |

---

## スキル

スキルは `gh skill install` でユーザースコープにインストールされ、全エージェント（Claude Code / GitHub Copilot / Codex / Gemini CLI）で共有されます。インストールスクリプトは `scripts/common/setup-ai-agents` を参照。

Gemini CLIにも外部スキルを配置します。Web検索の委譲先であるAntigravity CLIへは次のように配布できます。

```bash
bash scripts/common/distribute-skills --source ~/.agents/skills --target antigravity
```

### カスタムスキル (`ai-agents/skills/`)

`scripts/common/distribute-skills` で配布します。Bashと標準的なUnixコマンドを使用し、設定セットアップからも呼び出します。既存のClaudeコマンドも互換性のため維持します。

```bash
# 変更予定だけ確認
bash scripts/common/distribute-skills --dry-run

# Claude Code / Codex / Gemini CLI / Copilotに配布
bash scripts/common/distribute-skills

# 配布先・スキルを選択（どちらも複数指定可）
bash scripts/common/distribute-skills --target gemini --skill review

# Geminiアプリへ手動アップロードするフォルダーを書き出す
bash scripts/common/distribute-skills --export /tmp/gemini-skills

# 外部スキルも明示的に指定して配布（この例では外部スキルだけが対象）
bash scripts/common/distribute-skills --source ~/.agents/skills --target gemini
```

配布元はデフォルトで `ai-agents/skills/`。`名前.md` と `名前/SKILL.md` の両形式を扱い、後者では参照資料も配布します。`--source` の複数指定で自作・外部スキルをまとめられます。同名スキルが重複する場合は停止するため、配布元を分けて実行してください。

CLIの配置先は `~/.claude/skills/`、`~/.codex/skills/`、`~/.gemini/skills/`、`~/.gemini/antigravity-cli/skills/`、`~/.copilot/skills/` です。通常はファイル単位のシンボリックリンクで原本の変更を反映し、Windowsまたは `--copy` ではコピーします。既存ファイルは同じ原本へのリンクまたは同一内容ならスキップし、内容が異なる場合は書き込み前に停止します。コピーの更新時は既存の配布先を別名で退避して再実行してください。削除済みスキルの自動削除は行いません。

Geminiアプリでは、書き出された各 `名前/SKILL.md` または各スキルのフォルダーを「スキル」のアップロード画面から取り込みます。更新時も再アップロードが必要です。CLI向けツールや外部操作を前提とした指示はアプリでそのまま実行できるとは限りません。外部スキルの書き出し前には、参照資料の内容と再配布条件を確認してください。

仕様: [Geminiアプリのスキル作成・管理](https://support.google.com/gemini/answer/17094296)、[Gemini CLI Agent Skills](https://geminicli.com/docs/cli/skills/)。

| スキル | 説明 |
| --- | --- |
| `commit` | Conventional Commits 形式でコミット |
| `explain` | コード・ファイル・関数を日本語で解説 |
| `pr` | Pull Request の自動ドラフト作成 |
| `review` | 構造化コードレビュー |
| `security` | OWASP Top 10 観点のセキュリティ監査 |
| `setup-project` | 新規プロジェクトの初期セットアップ |
| `standup` | デイリースタンドアップ用サマリー生成 |
| `worktree` | git worktree を使った機能ブランチ管理 |

### 公式agent-browserスキル

[vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser)の公式スキルを`scripts/common/setup-ai-agents`から導入します。Claude Code / Codex / Gemini CLI / Copilotを対象にし、Antigravity CLIには既存の配布スクリプトで配置します。

既存環境へ個別に導入する場合:

```bash
npx skills add vercel-labs/agent-browser --skill agent-browser --global --agent claude-code codex gemini-cli github-copilot --yes
bash scripts/common/distribute-skills --source ~/.agents/skills --skill agent-browser --target antigravity
```

公式スキルは`agent-browser skills get core`でCLIのバージョンに対応した操作ガイドを読み込みます。探索的QAには`agent-browser skills get dogfood`で専用の手順を参照できます。ブラウザ操作の範囲と認証情報の扱いは[共通ガイド](../ai-agents/AGENTS.md#ブラウザでのローカルサービス確認)に従います。

利用例: 「agent-browserスキルで、http://localhost:3000 のフォームの必須入力と送信後の画面遷移を確認して」。通常のUI変更だけでは実行を必須にしません。

#### ブラウザの導入

agent-browser 本体は `scripts/macos/Brewfile` から導入します。ホストマシンの agent-browser が Chrome for Testing を起動して操作します。Chrome for Testing は普段使う Chrome とは別のアプリで、起動のたびに一時的なプロファイルを使うため、普段のブラウザのログイン状態・履歴・Cookie には触れません。

ブラウザテストを使いたくなったら、初回に一度だけ Chrome for Testing を `~/.agent-browser/browsers` にダウンロードします。

```bash
agent-browser install
```

HTTPS の開発サーバーを開く場合は、`mkcert -install` で mkcert CA をホストマシンに登録しておきます。Chrome for Testing はホストマシンに登録された CA を信頼するため、追加の設定は不要です。

#### ブラウザ操作

タスクごとに一意なセッション名を使い、操作後は自分のセッションを閉じます。ホストマシンの開発サーバーは `http(s)://localhost:<port>` でそのまま開けます。

```bash
session="my-task-$(date +%s)"

agent-browser --session "$session" open https://localhost:5173
agent-browser --session "$session" snapshot -i
agent-browser --session "$session" close
```

#### 通信先の制限

設定ファイル: `ai-agents/agent-browser/config.json`

セットアップ時に `~/.agent-browser/config.json` へ配置し、通信先をホストマシンの開発サーバーに限定します。agent-browser 自身が読み込む設定なので、どのシェルやツールから実行しても効きます。

| 設定 | 値 | 効果 |
|---|---|---|
| `allowedDomains` | `localhost`・`127.0.0.1`・`[::1]` | 許可していないドメインへの通信（ページの移動、HTTP、WebSocket など）を止める。普段の Chrome やプロファイルにつながる `--cdp`・`--auto-connect`・`--profile` の利用も拒否する |
| `autoConnect` | `false` | 起動中の Chrome を探して接続する機能を無効にする |

外部の API・CDN・フォントなどが必要な場合は、そのコマンドだけ許可するドメインを指定します。指定した値は設定ファイルの値を置き換えるため、ローカルホストも含めます。

```bash
agent-browser --allowed-domains "localhost,127.0.0.1,[::1],fonts.googleapis.com,fonts.gstatic.com" --session "$session" open https://localhost
```

#### 制限の範囲

- 普段の Chrome・個人用プロファイル・保存済み認証情報には接続しません。`allowedDomains` が設定されている間は、これらへ接続する `--cdp`・`--auto-connect`・`--profile` が拒否されます。`--executable-path` で別のブラウザを指定することも避けます。
- 通信先の制限はブラウザ内の仕組みで、コマンドの引数で変えられます。誤操作を防ぐためのもので、OS レベルで通信を遮断するものではありません。
- ブラウザはコンテナなどで隔離せず、ホストマシンで動きます。ファイルのアップロードなどでホストマシンのファイルに触れられるため、ページの指示でファイルを選んだり開いたりしません。

### [awesome-copilot](https://github.com/github/awesome-copilot) スキル

| スキル | 説明 |
| --- | --- |
| [`lsp-setup`](https://github.com/github/awesome-copilot/tree/main/skills/lsp-setup) | LSP サーバーのインストールと設定 |
| [`acquire-codebase-knowledge`](https://github.com/github/awesome-copilot/tree/main/skills/acquire-codebase-knowledge) | コードベースの構造・アーキテクチャの把握 |
| [`context-map`](https://github.com/github/awesome-copilot/tree/main/skills/context-map) | タスク関連ファイルのマッピング |
| [`refactor-plan`](https://github.com/github/awesome-copilot/tree/main/skills/refactor-plan) | 複数ファイルにまたがるリファクタリング計画の作成 |
| [`prd`](https://github.com/github/awesome-copilot/tree/main/skills/prd) | 製品要件ドキュメント（PRD）の生成 |
| [`breakdown-test`](https://github.com/github/awesome-copilot/tree/main/skills/breakdown-test) | テスト戦略・品質検証計画の策定 |
| [`web-design-reviewer`](https://github.com/github/awesome-copilot/tree/main/skills/web-design-reviewer) | Web サイトのデザインレビューと修正 |

### [pm-skills](https://github.com/product-on-purpose/pm-skills) スキル

| スキル | 説明 |
| --- | --- |
| [`foundation-stakeholder-update`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/foundation-stakeholder-update) | ステークホルダー向け非同期アップデートの作成 |
| [`foundation-meeting-agenda`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/foundation-meeting-agenda) | 会議アジェンダの作成 |
| [`foundation-meeting-brief`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/foundation-meeting-brief) | 会議前の個人用戦略メモの作成 |
| [`foundation-meeting-recap`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/foundation-meeting-recap) | 会議後のサマリー・アクション一覧の作成 |
| [`foundation-meeting-synthesize`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/foundation-meeting-synthesize) | 複数会議をまたぐパターン・意思決定の分析 |
| [`foundation-stakeholder-briefings`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/foundation-stakeholder-briefings) | オーディエンス別ブリーフィング文書の生成 |
| [`discover-interview-synthesis`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/discover-interview-synthesis) | ユーザーインタビューの統合・インサイト抽出 |
| [`discover-stakeholder-summary`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/discover-stakeholder-summary) | ステークホルダーのニーズ・関心の整理 |
| [`define-problem-statement`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/define-problem-statement) | 問題定義ドキュメントの作成 |
| [`define-hypothesis`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/define-hypothesis) | 検証可能な仮説と成功指標の定義 |
| [`develop-adr`](https://github.com/product-on-purpose/pm-skills/tree/main/skills/develop-adr) | Architecture Decision Record（ADR）の作成 |

---

### [Anatomy](https://github.com/wheresryan22/anatomy)

技術的な仕組みを、精密なアイソメトリック図や操作できるSVG・HTML・Reactコンポーネントとして説明するスキルです。共通セットアップで全エージェントに配置します。開発元が動作を案内しているのはClaude Code、Codexなどで、Gemini CLI・Copilotでの動作は未確認です。

Node.js 20.10以降と、表示検証用のChromeまたはChromiumが必要です。Codexでは次のように呼び出します。

```text
$anatomy LRUキャッシュの仕組みを説明する図を作って、interactive
```

Claude Codeでは `/anatomy` を使います。`interactive` を付けると操作できる図になります。

---

## Codex

設定テンプレート: `ai-agents/codex/config.toml.template`

セットアップ時にOS別の設定を選び、ホームディレクトリなどのプレースホルダーを実際のパスへ置換して `~/.codex/config.toml` に生成します。macOSではインストール済みの `Codex.app` または `ChatGPT.app` の実行ファイルを参照します。MCPへ渡すパスは、受け取り側の `~` や環境変数の展開に依存しない絶対パスになります。`CODEX_HOME` はMCP設定から上書きせず、既定値または起動元の環境変数を使います。

`ai-agents/codex/config.toml` はPC固有設定としてGit管理から除外しています。既存の `~/.codex/config.toml` がこのファイルへのシンボリックリンクでも、そのまま利用できます。リンク先に追加されたプロジェクトの信頼設定などはコミットされません。共有する変更はテンプレートに記載してください。セットアップを再実行すると、リンクがある場合はリンク先もテンプレートの内容で上書きされるため、残したいローカル設定は事前に退避してください。

| 項目 | 値 | 説明 |
| --- | --- | --- |
| `model` | `gpt-5.5` | 使用モデル |
| `approval_policy` | `untrusted` | 信頼されていないコマンドは承認が必要 |
| `sandbox_mode` | `workspace-write` | ワークスペース内の書き込みのみ許可 |
| `personality` | `pragmatic` | 実用的なスタイル |
| `multi_agent` | `true` | マルチエージェント有効 |

---

## Antigravity CLI

各エージェントが利用するWeb検索の委譲先です。macOSは `brew install --cask antigravity-cli`、Windowsは `winget install --exact --id Google.AntigravityCLI` で導入できます。導入後はターミナルを開き直し、`agy` で初回のGoogleログインを行います。個人の無料プランには週単位の利用枠があります。

```bash
agy -p "Web検索で調べ、一次情報のURLと日付を添えて回答してください。ファイル変更やシェルコマンドの実行は不要です。"
```

macOSは `brew upgrade --cask antigravity-cli`、Windowsは `winget upgrade --exact --id Google.AntigravityCLI` で更新できます。共通ガイドの配置先は `~/.gemini/GEMINI.md` です。既存ファイルがある場合は上書きせず保持するため、古い検索指示がある場合は手動で更新してください。Gemini CLIの設定を新しい設定ファイルへそのままコピーしません。

自己更新でパッケージ管理下の実行ファイルが置き換わるのを防ぐため、`AGY_CLI_DISABLE_AUTO_UPDATE=true` を設定します。macOSは `terminal/zshenv`、Windowsはセットアップ時のユーザー環境変数で設定します。更新はHomebrew・wingetから行います。既存のtmuxペインでは `export AGY_CLI_DISABLE_AUTO_UPDATE=true` を実行し、そのシェルからAI CLIを起動し直してください。

スキルの配置先は `~/.gemini/antigravity-cli/skills/` です。`distribute-skills --target antigravity` で配布します。

公式資料: [導入](https://antigravity.google/docs/getting-started/)、[移行](https://antigravity.google/docs/cli/gcli-migration)、[非対話モード](https://antigravity.google/docs/cli/headless/)。

## Gemini CLI

開発用エージェントです。Gemini CLIを含む各エージェントのWeb検索は、共通ガイドに従ってAntigravity CLIへ委譲します。

セットアップ時に `ai-agents/gemini/settings.json` を `~/.gemini/settings.json` に配置し、共通ガイドを `~/.gemini/AGENTS.md` に配置します。

| 項目 | 値 | 説明 |
| --- | --- | --- |
| `context.fileName` | `["AGENTS.md", "GEMINI.md"]` | 両方のファイル名を指示書として読み込む |
| `theme` | `GitHub` | カラーテーマ |
| `autoAccept` | `false` | 操作の自動承認を無効化 |
| `sandbox` | `docker` | Docker サンドボックスで実行 |
| `vimMode` | `true` | Vim キーバインドを有効化 |
| `checkpointing.enabled` | `true` | チェックポイント機能を有効化 |
