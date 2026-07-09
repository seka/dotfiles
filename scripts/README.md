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
scripts/macos/macos-defaults
scripts/macos/Brewfile
```

## Windows

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Windows-specific files:

```text
scripts/windows/winget.json
scripts/windows/setup-runtimes.ps1
scripts/windows/setup-python-tools.ps1
scripts/windows/setup-ai-cli.ps1
scripts/windows/setup-ai-workspace.ps1
scripts/windows/setup-startup.ps1
```

## Common

These scripts are called by both entry points where possible:

```text
scripts/common/setup-pip
scripts/common/setup-ai-agents
scripts/common/setup-shell-config
scripts/common/setup-editor-config
scripts/common/setup-agent-config
```

`setup-pip` and `setup-ai-agents` are shared. OS-specific package installation stays in `scripts/macos` or `scripts/windows`.
