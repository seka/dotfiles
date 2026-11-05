$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install App Installer and rerun install.ps1."
}

Write-Host "==> Installing Antigravity CLI with winget"
& winget install --exact --id Google.AntigravityCLI --source winget --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
    throw "Antigravity CLI installation failed (exit code: $LASTEXITCODE)."
}
Write-Host "--> Antigravity CLI installed"
