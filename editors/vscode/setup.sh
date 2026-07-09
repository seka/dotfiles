#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Darwin*) VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User" ;;
  Linux*) VSCODE_USER_DIR="$HOME/.config/Code/User" ;;
  *)
    echo "VS Code setup.sh is for macOS/Linux. Windows uses install.ps1."
    exit 1
    ;;
esac

mkdir -p "$VSCODE_USER_DIR"

ln -sf "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
ln -sf "$SCRIPT_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

if command -v code >/dev/null 2>&1 && [ -f "$SCRIPT_DIR/extensions.txt" ]; then
  while IFS= read -r extension; do
    case "$extension" in
      ""|\#*) continue ;;
      *) code --install-extension "$extension" --force ;;
    esac
  done < "$SCRIPT_DIR/extensions.txt"
fi
