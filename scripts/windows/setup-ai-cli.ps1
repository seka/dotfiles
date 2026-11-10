$ErrorActionPreference = "Stop"

[Environment]::SetEnvironmentVariable("AGY_CLI_DISABLE_AUTO_UPDATE", "true", "User")
$env:AGY_CLI_DISABLE_AUTO_UPDATE = "true"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install App Installer and rerun install.ps1."
}

Write-Host "==> Installing Antigravity CLI with winget"
& winget install --exact --id Google.AntigravityCLI --source winget --accept-package-agreements --accept-source-agreements
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
    throw "Antigravity CLI installation failed (exit code: $LASTEXITCODE)."
}
Write-Host "--> Antigravity CLI installed"

if (-not (Get-Command vfox -ErrorAction SilentlyContinue)) {
    Write-Host "vfox was not found. Skipping Gemini CLI setup."
    exit 0
}

Write-Host "==> Installing Gemini CLI"
& vfox exec nodejs@latest -- npm install --global "@google/gemini-cli"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Gemini CLI installation failed. Continuing."
    exit 0
}
Write-Host "--> Gemini CLI installed"
