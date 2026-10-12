---
name: pr
description: |
  gh コマンドで Pull Request を作成する（タイトル・本文を自動ドラフト）
allowed-tools: [Bash(gh pr create:*), Bash(gh pr view:*), Bash(git log:*), Bash(git diff:*), Bash(git branch:*)]
argument-hint: [base-branch]
---

以下の手順で Pull Request を作成してください。

1. `git branch --show-current` で現在のブランチを確認する
2. base branch を特定する（引数があれば使用、なければ関連 PR と依存関係を確認し、stacked PR の場合は親 PR のブランチ、それ以外は main/master を自動検出）
3. `git log [base]...HEAD --oneline` で全コミットを確認する
4. `git diff [base]...HEAD` で全変更を分析する
5. 以下の形式で PR を作成する:
   - タイトル: 70字以内、変更の要旨を英語で
   - 本文: 日本語で以下のテンプレートを使用

## PR 本文テンプレート

```
## Summary
- （変更点を箇条書きで）

## Test plan
- [ ] （確認すべき項目を箇条書きで）
```

## ルール
- 関連する PR があり、変更が依存している、または共通の土台から段階的に積み上がる場合は、stacked PR を積極的に使用する。関連するだけで独立してマージできる変更は、無理に積み重ねない
- stacked PR は親 PR のブランチを base に指定し、`gh pr create --base "[親ブランチ]"` を使用する。差分にはその段の変更だけが含まれることを確認する
- stacked PR の本文には親 PR のリンク、依存関係、マージ順を記載する。親 PR のマージ後は、残る PR の base と差分を確認し、必要に応じて更新する
- `gh pr create --title "..." --body "..."` を使用する
- 既存の PR がある場合は `gh pr view` で確認してから作成する
- ドラフト PR の場合は `--draft` フラグを付与する
