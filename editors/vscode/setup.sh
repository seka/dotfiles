#!/bin/bash

# VS Code設定セットアップスクリプト

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# macOS標準のVS Code設定ディレクトリ
# 参照: https://code.visualstudio.com/docs/getstarted/settings
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

mkdir -p "$VSCODE_USER_DIR"

# 既存の設定ファイルをバックアップ（存在する場合）
if [ -f "$VSCODE_USER_DIR/settings.json" ] && [ ! -L "$VSCODE_USER_DIR/settings.json" ]; then
    mv "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup"
fi

if [ -f "$VSCODE_USER_DIR/keybindings.json" ] && [ ! -L "$VSCODE_USER_DIR/keybindings.json" ]; then
    mv "$VSCODE_USER_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json.backup"
fi

# シンボリックリンクを作成
ln -sf "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
ln -sf "$SCRIPT_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

# 拡張機能をインストール
if [ -f "$SCRIPT_DIR/extensions.txt" ]; then
    while IFS= read -r extension; do
        if [ -n "$extension" ]; then
            code --install-extension "$extension"
        fi
    done < "$SCRIPT_DIR/extensions.txt"
fi
