$ErrorActionPreference = "Stop"

Write-Host "==> Setting up AI workspace tools"

if (Get-Command herdr -ErrorAction SilentlyContinue) {
    Write-Host "--> Herdr already installed"
    exit 0
}

Write-Host "Installing Herdr Windows preview..."
try {
    $Installer = Invoke-RestMethod -Uri "https://herdr.dev/install.ps1"
    Invoke-Expression $Installer
} catch {
    Write-Host "Herdr setup failed. Continuing with the rest of setup."
    Write-Host "Try manually if needed:"
    Write-Host "  irm https://herdr.dev/install.ps1 | iex"
    Write-Host ("  " + $_.Exception.Message)
    exit 0
}

if (Get-Command herdr -ErrorAction SilentlyContinue) {
    Write-Host "--> Herdr installed"
} else {
    Write-Host "Herdr installer completed, but herdr was not found on PATH."
    Write-Host "Open a new PowerShell window and run: herdr --version"
}
