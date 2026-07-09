param(
    [switch]$ProfileOnly
)

$ErrorActionPreference = "Stop"

$Vfox = Get-Command vfox -ErrorAction SilentlyContinue
if (-not $Vfox) {
    Write-Host "vfox was not found after winget import. Open a new PowerShell window and rerun install.ps1."
    exit 0
}

$PowerShellProfile = $PROFILE.CurrentUserAllHosts
$ProfileDirectory = Split-Path -Parent $PowerShellProfile
New-Item -ItemType Directory -Force -Path $ProfileDirectory | Out-Null
if (-not (Test-Path $PowerShellProfile)) {
    New-Item -ItemType File -Force -Path $PowerShellProfile | Out-Null
}

$ProfileBlockStart = "# dotfiles: begin windows environment"
$ProfileBlockEnd = "# dotfiles: end windows environment"
$LegacyVfoxActivation = 'Invoke-Expression "$(vfox activate pwsh)"'
$PreviousVfoxActivation = @'
$vfoxExecutable = Join-Path $env:ProgramFiles "vfox\vfox.exe"
if (Test-Path $vfoxExecutable) {
    Invoke-Expression "$(& $vfoxExecutable activate pwsh)"
}
'@
$DotfilesProfileBlock = @'
# dotfiles: begin windows environment
$machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$env:PATH = "$machinePath;$userPath"

$vfoxExecutable = Join-Path $env:ProgramFiles "vfox\vfox.exe"
if (Test-Path $vfoxExecutable) {
    Invoke-Expression "$(& $vfoxExecutable activate pwsh)"

    $vfoxGlobalPaths = @(
        "$HOME\.vfox\sdks\nodejs"
        "$HOME\.vfox\sdks\java\bin"
        "$HOME\.vfox\sdks\golang\bin"
        "$HOME\.vfox\sdks\golang\packages\bin"
        "$HOME\.vfox\sdks\python"
        "$HOME\.vfox\sdks\python\Scripts"
        "$HOME\.vfox\sdks\ruby\bin"
        "$HOME\.vfox\sdks\ruby\share\gems\bin"
    ) | Where-Object { Test-Path $_ }

    $env:PATH = (($vfoxGlobalPaths + @($env:PATH)) -join ";")
}
# dotfiles: end windows environment
'@
$ProfileContent = Get-Content -Raw -Path $PowerShellProfile
if ($null -eq $ProfileContent) {
    $ProfileContent = ""
}
$ManagedBlockPattern = "(?s)[\r\n]*$([regex]::Escape($ProfileBlockStart)).*?$([regex]::Escape($ProfileBlockEnd))[\r\n]*"
$DotfilesProfileBlock = $DotfilesProfileBlock.Trim()

if ($ProfileContent -match $ManagedBlockPattern) {
    $ProfileContent = [regex]::Replace(
        $ProfileContent,
        $ManagedBlockPattern,
        { $DotfilesProfileBlock + [Environment]::NewLine + [Environment]::NewLine },
        1
    )
} elseif ($ProfileContent.Contains($PreviousVfoxActivation.Trim())) {
    $ProfileContent = $ProfileContent.Replace($PreviousVfoxActivation.Trim(), $DotfilesProfileBlock)
} elseif ($ProfileContent.Contains($LegacyVfoxActivation)) {
    $ProfileContent = $ProfileContent.Replace($LegacyVfoxActivation, $DotfilesProfileBlock)
} elseif ($ProfileContent.Trim()) {
    $ProfileContent = $DotfilesProfileBlock + [Environment]::NewLine + [Environment]::NewLine + $ProfileContent.TrimEnd()
} else {
    $ProfileContent = $DotfilesProfileBlock
}

Set-Content -Encoding UTF8 -Path $PowerShellProfile -Value $ProfileContent

if ($ProfileOnly) {
    Write-Host "--> PowerShell profile updated: $PowerShellProfile"
    exit 0
}

Write-Host "==> Installing latest runtimes with vfox"
$Runtimes = @("nodejs", "java", "golang", "ruby")
$FailedRuntimes = @()

foreach ($Runtime in $Runtimes) {
    Write-Host "Installing $Runtime@latest..."
    & vfox install --yes "$Runtime@latest"
    if ($LASTEXITCODE -ne 0) {
        $FailedRuntimes += $Runtime
        continue
    }

    & vfox use --global "$Runtime@latest"
    if ($LASTEXITCODE -ne 0) {
        $FailedRuntimes += $Runtime
    }
}

Write-Host "Installing python..."
$PythonVersions = & vfox search python |
    Select-String -Pattern '\b\d+\.\d+\.\d+\b' -AllMatches |
    ForEach-Object { $_.Matches.Value } |
    Select-Object -Unique

$PythonInstalled = $false
foreach ($PythonVersion in $PythonVersions) {
    & vfox install --yes "python@$PythonVersion"
    if ($LASTEXITCODE -ne 0) {
        continue
    }

    & vfox use --global "python@$PythonVersion"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "--> python $PythonVersion"
        $PythonInstalled = $true
        break
    }
}

if (-not $PythonInstalled) {
    $FailedRuntimes += "python"
}

if ($FailedRuntimes.Count -gt 0) {
    Write-Host ("Runtime setup failed for: " + ($FailedRuntimes -join ", "))
    Write-Host "Rerun install.ps1 to retry them."
} else {
    Write-Host "--> Latest runtimes installed"
}
