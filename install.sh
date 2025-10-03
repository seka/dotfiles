#!/bin/bash

set -o errexit -o nounset -o pipefail

# ------------------------------
# global variable
# ------------------------------
DOTFILES_ROOT=$(cd $(dirname $0);pwd)

# ------------------------------
# scripts
# ------------------------------
bash scripts/setup-brew
bash scripts/setup-login-shell
bash scripts/macos-defaults
bash scripts/setup-pip

# ------------------------------
# XDG Base Directory setup
# ------------------------------
mkdir -p ~/.config/{git,zsh}
mkdir -p ~/.local/state/zsh
mkdir -p ~/.claude

# ------------------------------
# symlinks
# ------------------------------
for F in $(find {git,terminal} -type f -not -name '.*'); do
  filename=$(basename $F)
  case "$F" in
    "terminal/zshenv") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.zshenv" ;;
    "terminal/zshrc") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/zsh/.zshrc" ;;
    "terminal/tigrc") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.tigrc" ;;
    "terminal/.tmux.conf") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.tmux.conf" ;;
    "terminal/"*) ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/zsh/$filename" ;;
    "git/"*) ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/git/$filename" ;;
  esac
done

ln -sfn "$DOTFILES_ROOT/editors/vim/nvim" "$HOME/.config/nvim"

# ------------------------------
# Claude AI settings
# ------------------------------
ln -sf "$DOTFILES_ROOT/ai-agents/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -sf "$DOTFILES_ROOT/ai-agents/claude/settings.json" "$HOME/.claude/settings.json"

