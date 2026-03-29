---
name: commit
description: |
  Conventional Commits 形式でコミットメッセージを生成し、git commit を実行する
allowed-tools: [Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*)]
---

以下の手順で Conventional Commits 形式のコミットを作成してください。

1. `git status` でステージング状態を確認する
2. `git diff --staged` でステージ済み変更を分析する（空なら `git diff` も確認）
3. `git log --oneline -10` で既存のコミットスタイルを参照する
4. 変更内容から以下を判定する:
   - **type**: feat / fix / chore / docs / refactor / test / ci / build / perf のいずれか
   - **scope**: 変更されたディレクトリ名・モジュール名から推定（省略可）
   - **message**: 英語・現在形・50字以内
5. `git commit -m "type(scope): message"` を実行する

## ルール
- メッセージは英語・現在形（"add" ✓ / "added" ✗）
- Breaking change は `!` を付与: `feat!: ...`
- 複数の独立した変更は分割コミットを提案する
- ステージされていないファイルがある場合はユーザーに確認する
