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

DOTFILES_OS=macos bash "$DOTFILES_ROOT/scripts/common/setup-pip"
DOTFILES_OS=macos DOTFILES_ROOT="$DOTFILES_ROOT" bash "$DOTFILES_ROOT/scripts/common/setup-shell-config"
DOTFILES_OS=macos DOTFILES_ROOT="$DOTFILES_ROOT" bash "$DOTFILES_ROOT/scripts/common/setup-editor-config"
DOTFILES_OS=macos DOTFILES_ROOT="$DOTFILES_ROOT" bash "$DOTFILES_ROOT/scripts/common/setup-agent-config"
DOTFILES_OS=macos bash "$DOTFILES_ROOT/scripts/common/setup-ai-agents" || echo "AI agent setup failed. Local dotfiles are already installed."

echo "==> dotfiles setup completed"
