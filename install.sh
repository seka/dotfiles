#!/bin/bash

set -o errexit -o nounset -o pipefail

# ------------------------------
# global variable
# ------------------------------
DOTFILES_ROOT=$(cd $(dirname $0);pwd)

# ------------------------------
# scripts
# ------------------------------
echo "==> Running scripts/setup-brew"
bash scripts/setup-brew
echo "--> Completed scripts/setup-brew"

echo "==> Running scripts/setup-login-shell"
bash scripts/setup-login-shell
echo "--> Completed scripts/setup-login-shell"

echo "==> Running scripts/macos-defaults"
bash scripts/macos-defaults
echo "--> Completed scripts/macos-defaults"

echo "==> Running scripts/setup-pip"
bash scripts/setup-pip
echo "--> Completed scripts/setup-pip"

# ------------------------------
# XDG Base Directory setup
# ------------------------------
echo "==> Ensuring XDG base directories exist"
mkdir -p ~/.config/{git,zsh}
mkdir -p ~/.local/state/zsh
echo "--> XDG base directories ready"

# ------------------------------
# symlinks
# ------------------------------
echo "==> Creating dotfile symlinks"
for F in $(find {git,terminal} -type f -not -name '.*'); do
  filename=$(basename $F)
  case "$F" in
    "terminal/zshenv") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.zshenv" ;;
    "terminal/zshrc") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/zsh/.zshrc" ;;
    "terminal/tigrc") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.tigrc" ;;
    "terminal/tmux.conf") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.tmux.conf" ;;
    "terminal/"*) ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/zsh/$filename" ;;

    # git の config を以前は XDG 形式で管理していたが、SandBox制限に引っかかるので
    # これだけグローバルで管理することにする
    "git/config") cp "$DOTFILES_ROOT/$F" "$HOME/.gitconfig" ;;
    "git/ignore") cp "$DOTFILES_ROOT/$F" "$HOME/.gitignore_global" ;;
  esac
done
echo "--> Dotfile symlinks created"

echo "==> Linking Neovim configuration"
ln -sfn "$DOTFILES_ROOT/editors/vim/nvim" "$HOME/.config/nvim"
echo "--> Neovim configuration linked"

# ------------------------------
# Claude AI settings
# ------------------------------
echo "==> Linking Claude settings"
mkdir -p ~/.claude
ln -sf "$DOTFILES_ROOT/ai-agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
ln -sf "$DOTFILES_ROOT/ai-agents/claude/settings.json" "$HOME/.claude/settings.json"
echo "--> Claude settings linked"

# ------------------------------
# Codex settings
# ------------------------------
echo "==> Linking Codex settings"
mkdir -p ~/.codex
ln -sf "$DOTFILES_ROOT/ai-agents/codex/CODEX.md" "$HOME/.codex/CODEX.md"
ln -sf "$DOTFILES_ROOT/ai-agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -sf "$DOTFILES_ROOT/ai-agents/codex/config.toml" "$HOME/.codex/config.toml"
echo "--> Codex settings linked"

# ------------------------------
# Gemini settings
# ------------------------------
echo "==> Linking Gemini settings"
mkdir -p ~/.config/gemini
ln -sf "$DOTFILES_ROOT/ai-agents/AGENTS.md" "$HOME/.config/gemini/GEMINI.md"
ln -sf "$DOTFILES_ROOT/ai-agents/gemini/settings.json" "$HOME/.config/gemini/settings.json"
echo "--> Gemini settings linked"

