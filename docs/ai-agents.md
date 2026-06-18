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
| 許可 | `terminal-notifier`, `gemini` |
| 拒否 | `curl`, `wget`, `sudo`, `.env.*` の読み取り |

**スキル一覧** (`ai-agents/skills/`):

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

共通エージェントガイドは `ai-agents/AGENTS.md` を参照。

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
