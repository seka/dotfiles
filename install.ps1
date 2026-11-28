$ErrorActionPreference = "Stop"

try {
    chcp.com 65001 | Out-Null
    [Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
} catch {
    Write-Host "Could not switch console encoding to UTF-8. Continuing."
}

$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"
$env:LANG = "C.UTF-8"

$DotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$WinGetFile = Join-Path $DotfilesRoot "scripts\windows\winget.json"
$LogDir = Join-Path $DotfilesRoot ".logs"
$WinGetLog = Join-Path $LogDir "winget-import.log"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install App Installer from Microsoft Store, then rerun .\install.ps1."
}

if ($env:DOTFILES_SKIP_WINGET -ne "1") {
    Write-Host "==> Installing Windows packages from scripts\windows\winget.json"
    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
    if (Test-Path $WinGetLog) {
        Remove-Item -Force -Path $WinGetLog
    }

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $wingetOutput = & winget import `
        --import-file $WinGetFile `
        --ignore-unavailable `
        --ignore-versions `
        --accept-package-agreements `
        --accept-source-agreements `
        --disable-interactivity `
        2>&1
    $wingetExitCode = $LASTEXITCODE
    $ErrorActionPreference = $previousErrorActionPreference
    $wingetOutput | ForEach-Object { Write-Host "$_" }
    $wingetOutput | ForEach-Object { "$_" } | Set-Content -Encoding UTF8 -Path $WinGetLog

    if ($wingetExitCode -ne 0) {
        Write-Host "winget import had failures. Continuing with the rest of setup."
        Write-Host "Review the log for failed packages: $WinGetLog"

        $failureLines = Select-String -Path $WinGetLog -Pattern "failed|error|no package|not found|unavailable|Installer failed" -CaseSensitive:$false
        if ($failureLines) {
            Write-Host "Possible failure lines:"
            $failureLines | Select-Object -First 20 | ForEach-Object {
                Write-Host ("  " + $_.Line)
            }
        }
    } else {
        Write-Host "--> Windows packages installed"
    }
}

$MachinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
$env:PATH = "$MachinePath;$UserPath"

if ($PSVersionTable.PSEdition -ne "Core") {
    $PowerShell7Candidates = @(
        "$env:ProgramFiles\PowerShell\7\pwsh.exe",
        "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe"
    )

    $PowerShell7 = $PowerShell7Candidates |
        Where-Object { Test-Path $_ } |
        Select-Object -First 1

    if (-not $PowerShell7) {
        $PowerShell7Command = Get-Command pwsh.exe -ErrorAction SilentlyContinue
        if ($PowerShell7Command) {
            $PowerShell7 = $PowerShell7Command.Source
        }
    }

    if ($PowerShell7) {
        Write-Host "==> Continuing setup with PowerShell 7"
        $env:DOTFILES_SKIP_WINGET = "1"
        & $PowerShell7 -NoProfile -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Path
        exit $LASTEXITCODE
    }

    Write-Host "PowerShell 7 was not found after winget import. Continuing with Windows PowerShell."
}

$PowerShellHost = (Get-Process -Id $PID).Path

Write-Host "==> Configuring development storage"
& "$DotfilesRoot\scripts\windows\setup-storage.ps1"

Write-Host "==> Setting up WSL2 platform"
& $PowerShellHost -NoProfile -ExecutionPolicy Bypass -File "$DotfilesRoot\scripts\windows\setup-wsl2.ps1"

Write-Host "==> Setting up language runtimes"
& $PowerShellHost -NoProfile -ExecutionPolicy Bypass -File "$DotfilesRoot\scripts\windows\setup-runtimes.ps1"

Write-Host "==> Setting up Python tools"
& $PowerShellHost -NoProfile -ExecutionPolicy Bypass -File "$DotfilesRoot\scripts\windows\setup-python-tools.ps1"

Write-Host "==> Setting up AI CLIs"
& $PowerShellHost -NoProfile -ExecutionPolicy Bypass -File "$DotfilesRoot\scripts\windows\setup-ai-cli.ps1"

Write-Host "==> Setting up AI workspace tools"
& $PowerShellHost -NoProfile -ExecutionPolicy Bypass -File "$DotfilesRoot\scripts\windows\setup-ai-workspace.ps1"

Write-Host "==> Configuring Explorer preferences"
& $PowerShellHost -NoProfile -ExecutionPolicy Bypass -File "$DotfilesRoot\scripts\windows\setup-explorer.ps1"

Write-Host "==> Configuring startup apps"
& $PowerShellHost -NoProfile -ExecutionPolicy Bypass -File "$DotfilesRoot\scripts\windows\setup-startup.ps1"

Write-Host "==> Installing shell and Git configuration"
& "$DotfilesRoot\scripts\windows\setup-shell-config.ps1"

Write-Host "==> Installing editor configuration"
& "$DotfilesRoot\scripts\windows\setup-editor-config.ps1"

Write-Host "==> Installing AI agent configuration"
& "$DotfilesRoot\scripts\windows\setup-agent-config.ps1"

try {
    & "$DotfilesRoot\scripts\windows\setup-ai-agents.ps1"
} catch {
    Write-Host "AI agent setup failed. Local dotfiles are already installed."
    Write-Host $_.Exception.Message
}

Write-Host "==> Windows dotfiles setup completed"
