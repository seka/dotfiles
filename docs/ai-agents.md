# AI エージェント設定

`ai-agents/` ディレクトリに各エージェントの設定ファイルをまとめています。

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
| 許可 | `gemini` |
| 拒否 | `curl`, `wget`, `sudo`, `.env.*` の読み取り |

共通エージェントガイドは `ai-agents/AGENTS.md` を参照。

---

## スキル

スキルは `gh skill install` でユーザースコープにインストールされ、全エージェント（Claude Code / GitHub Copilot / Codex / Gemini CLI）で共有されます。インストールスクリプトは `scripts/setup-ai-agents` を参照。

### カスタムスキル (`ai-agents/skills/`)

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

## Codex

設定ファイル: `ai-agents/codex/config.toml`

| 項目 | 値 | 説明 |
| --- | --- | --- |
| `model` | `gpt-5.5` | 使用モデル |
| `approval_policy` | `untrusted` | 信頼されていないコマンドは承認が必要 |
| `sandbox_mode` | `workspace-write` | ワークスペース内の書き込みのみ許可 |
| `personality` | `pragmatic` | 実用的なスタイル |
| `multi_agent` | `true` | マルチエージェント有効 |

---

## Gemini CLI

設定ファイル: `ai-agents/gemini/settings.json`

| 項目 | 値 | 説明 |
| --- | --- | --- |
| `theme` | `GitHub` | カラーテーマ |
| `autoAccept` | `false` | 操作の自動承認を無効化 |
| `sandbox` | `docker` | Docker サンドボックスで実行 |
| `vimMode` | `true` | Vim キーバインドを有効化 |
| `checkpointing.enabled` | `true` | チェックポイント機能を有効化 |
