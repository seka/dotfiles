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
bash scripts/osx-defaults
bash scripts/setup-pip

# ------------------------------
# XDG Base Directory setup
# ------------------------------
mkdir -p ~/.config/{git,zsh}
mkdir -p ~/.local/state/zsh

# ------------------------------
# symlinks
# ------------------------------
for F in $(find {git,terminal} -type f -not -name '.*'); do
  filename=$(basename $F)
  case "$F" in
    "terminal/zshenv") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.zshenv" ;;
    "terminal/zshrc") ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/zsh/.zshrc" ;;
    "terminal/"*) ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/zsh/$filename" ;;
    "git/"*) ln -sf "$DOTFILES_ROOT/$F" "$HOME/.config/git/$filename" ;;
  esac
done

ln -sf "$DOTFILES_ROOT/editors/vim/nvim" "$HOME/.config/nvim"

