$ErrorActionPreference = "Stop"

# Docker Desktop uses its WSL2 backend on Windows. This script enables only
# the Windows platform pieces required for that backend; it intentionally does
# not install Ubuntu or another user-facing Linux distribution.

function Test-IsAdministrator {
    $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = [Security.Principal.WindowsPrincipal]::new($Identity)
    return $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdministrator)) {
    if (Get-Command gsudo -ErrorAction SilentlyContinue) {
        Write-Host "==> Re-running WSL2 platform setup as administrator"
        & gsudo pwsh -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath
        exit $LASTEXITCODE
    }

    Write-Host "WSL2 platform setup requires administrator privileges."
    Write-Host "Install gsudo or rerun this script from an elevated PowerShell window."
    exit 0
}

Write-Host "==> Enabling WSL2 platform for Docker Desktop"

$Features = @(
    "Microsoft-Windows-Subsystem-Linux"
    "VirtualMachinePlatform"
)

$RestartNeeded = $false

foreach ($Feature in $Features) {
    $FeatureInfo = & dism.exe /Online /Get-FeatureInfo /FeatureName:$Feature /English
    $FeatureEnabled = $FeatureInfo | Select-String -Pattern "State : Enabled" -Quiet
    if ($FeatureEnabled) {
        Write-Host ("Already enabled: " + $Feature)
        continue
    }

    & dism.exe /Online /Enable-Feature /FeatureName:$Feature /All /NoRestart
    if ($LASTEXITCODE -ne 0) {
        Write-Host ("Could not enable Windows feature: " + $Feature)
        continue
    }

    $RestartNeeded = $true
    $FeatureInfo = & dism.exe /Online /Get-FeatureInfo /FeatureName:$Feature /English
    $RestartRequired = $FeatureInfo | Select-String -Pattern "Restart Required : Possible|Restart Required : Required" -Quiet
    if ($RestartRequired) {
        $RestartNeeded = $true
    }
}

if (Get-Command winget -ErrorAction SilentlyContinue) {
    $WslPackage = & winget list --id Microsoft.WSL --exact --source winget 2>$null
    if ($LASTEXITCODE -ne 0 -or -not ($WslPackage | Select-String -Pattern "Microsoft.WSL" -Quiet)) {
        Write-Host "Installing Windows Subsystem for Linux package..."
        & winget install `
            --id Microsoft.WSL `
            --exact `
            --source winget `
            --accept-package-agreements `
            --accept-source-agreements `
            --disable-interactivity
        if ($LASTEXITCODE -eq 0) {
            $RestartNeeded = $true
        }
    }
}

try {
    & wsl --install --no-distribution
    if ($LASTEXITCODE -ne 0) {
        Write-Host "wsl --install --no-distribution did not complete successfully."
        $RestartNeeded = $true
    }
} catch {
    Write-Host "Could not run wsl --install --no-distribution."
    Write-Host ("  " + $_.Exception.Message)
    $RestartNeeded = $true
}

try {
    & wsl --set-default-version 2
} catch {
    Write-Host "Could not set WSL default version to 2."
    Write-Host ("  " + $_.Exception.Message)
}

if ($RestartNeeded) {
    Write-Host "A Windows restart is required before Docker Desktop can use WSL2."
} else {
    Write-Host "--> WSL2 platform configured"
}
