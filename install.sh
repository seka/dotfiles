#!/bin/bash

set -o errexit -o nounset -o pipefail

# ------------------------------
# global variable
# ------------------------------
DOTFILES_ROOT=$(cd $(dirname $0);pwd)

# ------------------------------
# scripts
# ------------------------------
bash scripts/brew
bash scripts/brew-cask
bash scripts/setup-login-shell
bash scripts/osx-defaults

# ------------------------------
# symlink
# ------------------------------
for F in $(find {terminal,git} -type f -not -name '.*'); do
  ln -sf "$DOTFILES_ROOT/$F" "$HOME/.$(basename $F)"
done

# xdg-config
mkdir -p ~/.config
ln -sf "$DOTFILES_ROOT/editors/vim/nvim" "$HOME/.config/nvim"

