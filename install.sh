#!/bin/bash

set -o errexit -o nounset -o pipefail

# ------------------------------
# global variable
# ------------------------------
DOTFILES_ROOT=$(cd $(dirname $0);pwd)

# ------------------------------
# sudo pre-authentication
# スクリプト冒頭で1回だけパスワードを求め、以降はキャッシュを使い回す
# ------------------------------
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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

echo "==> Running scripts/setup-ai-agents"
bash scripts/setup-ai-agents
echo "--> Completed scripts/setup-ai-agents"

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

    "git/config") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/git/config" ;;
    "git/ignore") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/git/ignore" ;;
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

# Claude commands (custom skills)
echo "==> Linking Claude commands"
mkdir -p ~/.claude/commands
for F in ai-agents/skills/*.md; do
  ln -sf "$DOTFILES_ROOT/$F" "$HOME/.claude/commands/$(basename $F)"
done
echo "--> Claude commands linked"

# Gemini skills (custom skills)
echo "==> Linking Gemini skills"
for F in ai-agents/skills/*.md; do
  skill_name=$(basename "$F" .md)
  mkdir -p "$HOME/.gemini/skills/$skill_name"
  ln -sf "$DOTFILES_ROOT/$F" "$HOME/.gemini/skills/$skill_name/SKILL.md"
done
echo "--> Gemini skills linked"

# ------------------------------
# Codex settings
# ------------------------------
echo "==> Linking Codex settings"
mkdir -p ~/.codex
ln -sf "$DOTFILES_ROOT/ai-agents/codex/CODEX.md" "$HOME/.codex/CODEX.md"
ln -sf "$DOTFILES_ROOT/ai-agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -sf "$DOTFILES_ROOT/ai-agents/codex/config.toml" "$HOME/.codex/config.toml"
echo "--> Codex settings linked"

# Codex skills (custom skills)
echo "==> Linking Codex skills"
for F in ai-agents/skills/*.md; do
  skill_name=$(basename "$F" .md)
  mkdir -p "$HOME/.codex/skills/$skill_name"
  ln -sf "$DOTFILES_ROOT/$F" "$HOME/.codex/skills/$skill_name/SKILL.md"
done
echo "--> Codex skills linked"

# ------------------------------
# Gemini settings
# ------------------------------
echo "==> Linking Gemini settings"
mkdir -p ~/.config/gemini
ln -sf "$DOTFILES_ROOT/ai-agents/AGENTS.md" "$HOME/.config/gemini/GEMINI.md"
ln -sf "$DOTFILES_ROOT/ai-agents/gemini/settings.json" "$HOME/.config/gemini/settings.json"
echo "--> Gemini settings linked"
