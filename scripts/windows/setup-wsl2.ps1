$ErrorActionPreference = "Stop"

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
    $FeatureState = Get-WindowsOptionalFeature -Online -FeatureName $Feature
    if ($FeatureState.State -eq "Enabled") {
        Write-Host ("Already enabled: " + $Feature)
        continue
    }

    $Result = Enable-WindowsOptionalFeature -Online -FeatureName $Feature -All -NoRestart
    if ($Result.RestartNeeded) {
        $RestartNeeded = $true
    }
}

try {
    & wsl --install --no-distribution
    if ($LASTEXITCODE -ne 0) {
        Write-Host "wsl --install --no-distribution did not complete successfully."
    }
} catch {
    Write-Host "Could not run wsl --install --no-distribution."
    Write-Host ("  " + $_.Exception.Message)
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
