---
name: setup-project
description: |
  新規プロジェクトの初期セットアップを実行する（git init・プロジェクト初期化・エージェント設定・LSP 設定）
allowed-tools: [Bash(git:*), Bash(npm:*), Bash(npx:*), Bash(go:*), Bash(pip:*), Bash(uv:*), Bash(bundle:*), Bash(cargo:*), Bash(ls:*), Bash(find:*), Read, Write, Glob]
argument-hint: <言語/フレームワーク名>
---

新規プロジェクトを以下の手順でセットアップしてください。

## 手順

### 1. プロジェクト構成の確認

最初にユーザーに以下を確認する:

- プロジェクトの概要（何を作るか）
- ディレクトリ構成（モノレポか単一言語か）
  - 単一言語: 言語・フレームワーク・モジュール名
  - モノレポ: 各ディレクトリの役割と言語（例: `backend/` → Go, `frontend/` → Next.js）

確認した構成を箇条書きで整理してユーザーに提示し、承認を得てから次のステップに進む。

### 2. Git 初期化

`.git` が存在しない場合のみ実行する:

```bash
git init
```

### 3. .gitignore 生成

言語に合わせた `.gitignore` を生成する。代表的なパターン:

- **Node.js**: `node_modules/`, `.env`, `dist/`, `.next/`
- **Go**: `*.exe`, `*.test`, `vendor/`
- **Python**: `__pycache__/`, `.venv/`, `*.pyc`, `.env`
- **Rust**: `target/`

既に `.gitignore` が存在する場合はスキップする。

### 4. プロジェクト初期化

各言語のディレクトリで、既存の設定ファイルがない場合のみ実行する:

- **Node.js**: `npm init -y`
- **Go**: `go mod init <module-name>`
- **Python**: `uv init` または `pip install` 手順を案内
- **Rust**: `cargo init`

モノレポの場合は各ディレクトリに対して順番に実行する。

### 5. エージェント設定ファイルの生成

以下のファイルが存在しない場合に生成する:

#### `CLAUDE.md`

プロジェクト固有の Claude 向け指示書。最低限以下を含める:
- プロジェクト概要（1-3文）
- 使用技術スタック
- よく使うコマンド（build, test, lint）

#### `.github/copilot-instructions.md`

GitHub Copilot 向け指示書。`CLAUDE.md` と同等の内容を Copilot 形式で記述する。

#### `AGENTS.md`（任意）

複数エージェントで使う共通ルールがある場合に生成する。

### 6. GitHub テンプレートの生成

以下のファイルが存在しない場合に生成する:

#### `.github/pull_request_template.md`

```markdown
## Summary

## Changes

## Test plan

- [ ]

## Screenshots (if applicable)
```

#### `.github/ISSUE_TEMPLATE/bug_report.md`

```markdown
---
name: Bug report
about: バグの報告
labels: bug
---

## Description

## Steps to Reproduce

1.

## Expected Behavior

## Actual Behavior

## Environment
```

#### `.github/ISSUE_TEMPLATE/feature_request.md`

```markdown
---
name: Feature request
about: 機能追加の提案
labels: enhancement
---

## Summary

## Motivation

## Proposed Solution

## Alternatives Considered
```

### 7. README.md の生成

`README.md` が存在しない場合のみ、以下の構成で生成する:

```markdown
# <プロジェクト名>

## Overview

## Getting Started

### Prerequisites

### Setup

## Usage

## Development

## License
```

※ License は必要に応じて追加すること

### 8. LSP 設定

`/lsp-setup` スキルを呼び出して、各言語に対応した LSP をセットアップする。モノレポの場合は使用する言語ごとに繰り返す。

### 9. 初期コミット

```bash
git add .
git commit -m "chore: initial project setup"
```

## ルール

- 既存ファイルは上書きしない。存在する場合はスキップしてユーザーに通知する
- 言語が特定できない場合はユーザーに確認する
- 各ステップの完了をユーザーに報告しながら進める
- 日本語で出力する
