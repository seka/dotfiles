---
name: review
description: |
  構造化コードレビューを実行する（Bug / Risk / Regression / Missing Test の重要度順）
allowed-tools: [Bash(git diff:*), Bash(git log:*), Bash(git blame:*), Bash(gh pr diff:*), Read, Grep, Glob]
argument-hint: [PR番号 or ブランチ名]
---

以下の手順で構造化コードレビューを実施してください。

## 対象の決定

- 引数なし: `git diff HEAD` を対象
- PR番号（数字）: `gh pr diff [番号]` を対象
- ブランチ名: `git diff [ブランチ]...HEAD` を対象

## レビュー観点

以下の優先順位で問題を分類して報告する:

1. **Bug** — 明確なバグ・ロジックエラー
2. **Risk** — 本番障害・セキュリティ・パフォーマンスリスク
3. **Regression** — 既存機能を壊す可能性
4. **Missing Test** — テストが不足している箇所

## 出力フォーマット

各項目は以下の形式で列挙する:

```
### [分類] severity: Critical / Warning / Info

**ファイル**: path/to/file.ts:行番号
**問題**: 何が問題か
**理由**: なぜ問題なのか
**提案**: どう修正すべきか
```

## ルール
- 不確かな点は質問として切り出し、仮定を明記する
- 良い変更点も簡潔に記載する
- 日本語で出力する
