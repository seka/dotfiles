# scripts

Setup scripts are split by responsibility:

```text
scripts/
  common/   # Shared setup used by macOS and Windows after bootstrap
  macos/    # macOS-only bootstrap scripts and Brewfile
  windows/  # Windows-only bootstrap scripts and winget manifest
```

## macOS

Run from the repository root:

```bash
./install.sh
```

macOS-specific scripts:

```text
scripts/macos/setup-brew
scripts/macos/setup-login-shell
scripts/macos/setup-tmux
scripts/macos/setup-browserless
scripts/macos/macos-defaults
scripts/macos/Brewfile
```

`setup-tmux` places the tmux configuration, bootstraps TPM, and installs the plugins declared in `terminal/tmux.conf`. Existing plugin checkouts are reused.

`setup-browserless` configures machine-local credentials and the agent-browser connection, then starts the Browserless Compose service. If Docker is not running, it prints the manual setup command and skips startup.

## Windows

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Windows-specific files:

```text
scripts/windows/winget.json
scripts/windows/setup-wsl2.ps1
scripts/windows/setup-runtimes.ps1
scripts/windows/setup-python-tools.ps1
scripts/windows/setup-ai-cli.ps1
scripts/windows/setup-ai-workspace.ps1
scripts/windows/setup-explorer.ps1
scripts/windows/setup-startup.ps1
```

## Common

These scripts are called by both entry points where possible:

```text
scripts/common/setup-python-tools
scripts/common/setup-ai-agents
scripts/common/setup-shell-config
scripts/common/setup-editor-config
scripts/common/setup-agent-config
```

`setup-ai-agents` is shared. Python tools use `common/setup-python-tools` on macOS and the native `windows/setup-python-tools.ps1` on Windows.

Both Python tool scripts install pynvim, codespell, and Ruff with `uv tool install --managed-python`, using isolated environments backed by uv-managed Python.
They also install the latest stable Python with the experimental `uv python install --default` option.
uv itself is installed from the macOS Brewfile or the Windows winget manifest; the Python tool scripts require it to be available.
The zsh and PowerShell configurations put `~/.local/bin` first on `PATH` to expose uv-managed Python and tools.
On Windows, `uv tool update-shell` also registers the executable directory in the user PATH; open a new terminal after setup.
Existing executables owned by other tools are not forcibly replaced. Before migrating existing pipx installations, uninstall the matching packages with `pipx uninstall <package>` and rerun setup. Remove unused pipx and duplicate Homebrew tools after confirming the uv installations work.
