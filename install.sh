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
# symlink
# ------------------------------
for F in $(find {terminal,git} -type f -not -name '.*'); do
  ln -sf "$DOTFILES_ROOT/$F" "$HOME/.$(basename $F)"
done

# xdg-config
mkdir -p ~/.config
ln -sf "$DOTFILES_ROOT/editors/vim/nvim" "$HOME/.config/nvim"

