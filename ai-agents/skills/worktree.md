---
name: worktree
description: |
  git-worktree-runner (gtr) を使って新機能ブランチのワークツリーを作成し、実装・マージまでのワークフローをガイドする
allowed-tools: [Bash(git gtr:*), Bash(git checkout:*), Bash(git merge:*), Bash(git branch:*), Bash(git status:*), Bash(git log:*)]
argument-hint: <feature/branch-name>
---

新しい実装を追加する際、 **git-worktree-runner (gtr)** を使った機能開発ワークフローを実行してください。

## ワークフロー手順

### 1. ワークツリー作成

引数で指定されたブランチ名（なければ作業内容から命名を提案）でワークツリーを作成する:

```bash
git gtr new feature/your-feature-name
```

- ブランチ名は `feature/`, `fix/`, `chore/` などのプレフィックスを付ける
- `.env` や `node_modules` などは自動コピーされる

### 2. 実装

作成されたワークツリーディレクトリ内で実装を行う。メインリポジトリから実行する場合:

```bash
git gtr run feature/your-feature-name <コマンド>
```

### 3. コミット

ワークツリーディレクトリ内で Conventional Commits 形式でコミット:

```bash
git add .
git commit -m "feat(scope): 変更内容"
```

### 4. マスターへのマージ

検証後、メインリポジトリに戻ってマージ:

```bash
git checkout master
git merge feature/your-feature-name
```

### 5. クリーンアップ

マージ済みワークツリーを一括削除:

```bash
git gtr clean --merged
```

個別削除の場合:

```bash
git gtr rm feature/your-feature-name
git branch -d feature/your-feature-name
```

## ルール

- 必ず `develop` や `master` / `main` をベースにワークツリーを作成する
- 実装前に `git status` で現在のリポジトリ状態を確認する
- マージ前に変更内容を `git log` で確認してからユーザーに承認を求める
- 破壊的操作（`git gtr clean --merged` / `git gtr rm`）は実行前にユーザーに確認する
