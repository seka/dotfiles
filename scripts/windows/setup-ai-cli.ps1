$ErrorActionPreference = "Stop"

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
