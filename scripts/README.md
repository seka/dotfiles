# Setup scripts

- `scripts/macos/` contains the macOS Bash scripts and Brewfile.
- `scripts/windows/` contains the Windows PowerShell scripts and winget manifest.
- `scripts/resources/` contains data files used by both installers, including the GitHub skill list in `agent-skills.tsv`.

## macOS

Run `./install.sh` from the repository root. The installer uses Homebrew for packages, installs shell and editor settings as symbolic links, and generates the Codex configuration from its templates.

`setup-tmux` places the tmux configuration, bootstraps TPM, and installs the plugins declared in `terminal/tmux.conf`. Existing plugin checkouts are reused.

## Windows

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Setup uses PowerShell and winget. It copies Git, tig, editor, and AI agent settings into the user's configuration directories. Neovim settings go under `%LOCALAPPDATA%\nvim` by default, honoring `XDG_CONFIG_HOME` and `NVIM_APPNAME` when set. Re-running setup updates the repository's files in place and keeps other files in the Neovim directory. If you previously customized `~/.config/nvim`, check that directory for settings you want to carry over.

## Python tools

Both Python tool scripts install pynvim, codespell, and Ruff with `uv tool install --managed-python`, using isolated environments backed by uv-managed Python.
They also install the latest stable Python with the experimental `uv python install --default` option.
uv itself is installed from the macOS Brewfile or the Windows winget manifest; the Python tool scripts require it to be available.
The zsh and PowerShell configurations put `~/.local/bin` first on `PATH` to prioritize user-installed commands.
On Windows, `uv tool update-shell` also registers the executable directory in the user PATH; open a new terminal after setup.
Existing executables owned by other tools are not forcibly replaced. Before migrating existing pipx installations, uninstall the matching packages with `pipx uninstall <package>` and rerun setup. Remove unused pipx and duplicate Homebrew tools after confirming the uv installations work.
