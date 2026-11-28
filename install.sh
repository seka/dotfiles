#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

DOTFILES_ROOT=$(cd "$(dirname "$0")"; pwd)

if [[ "$(uname -s)" != Darwin* ]]; then
  echo "install.sh is for macOS. Use install.ps1 on Windows."
  exit 1
fi

run_if_exists() {
  local script="$1"
  if [[ -x "$DOTFILES_ROOT/$script" || -f "$DOTFILES_ROOT/$script" ]]; then
    echo "==> Running $script"
    bash "$DOTFILES_ROOT/$script"
    echo "--> Completed $script"
  fi
}

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

run_if_exists scripts/macos/setup-brew
run_if_exists scripts/macos/setup-login-shell
run_if_exists scripts/macos/macos-defaults

bash "$DOTFILES_ROOT/scripts/macos/setup-python-tools"
bash "$DOTFILES_ROOT/scripts/macos/setup-shell-config"
run_if_exists scripts/macos/setup-tmux
bash "$DOTFILES_ROOT/scripts/macos/setup-editor-config"
bash "$DOTFILES_ROOT/scripts/macos/setup-agent-config"
bash "$DOTFILES_ROOT/scripts/macos/setup-ai-agents" || echo "AI agent setup failed. Local dotfiles are already installed."

echo "==> dotfiles setup completed"
