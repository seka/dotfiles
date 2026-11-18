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

    $vfoxHome = Join-Path $HOME ".vfox"

    $vfoxGlobalPaths = @(
        (Join-Path $vfoxHome "sdks\nodejs")
        (Join-Path $vfoxHome "sdks\java\bin")
        (Join-Path $vfoxHome "sdks\golang\bin")
        (Join-Path $vfoxHome "sdks\golang\packages\bin")
        (Join-Path $vfoxHome "sdks\ruby\bin")
        (Join-Path $vfoxHome "sdks\ruby\share\gems\bin")
    ) | Where-Object { Test-Path $_ }

    $env:PATH = (($vfoxGlobalPaths + @($env:PATH)) -join ";")

    foreach ($name in @("GOPATH", "GOBIN", "GOMODCACHE", "GOCACHE")) {
        $userValue = [Environment]::GetEnvironmentVariable($name, "User")
        if ($userValue) {
            Set-Item -Path "Env:$name" -Value $userValue
        }
    }
}
# ユーザー単位で導入したコマンドを優先するため、vfox初期化後に~/.local/binをPATHの先頭へ追加する。
$userBin = Join-Path $HOME ".local\bin"
if (Test-Path $userBin) {
    $env:PATH = "$userBin;$env:PATH"
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

if ($FailedRuntimes.Count -gt 0) {
    Write-Host ("Runtime setup failed for: " + ($FailedRuntimes -join ", "))
    Write-Host "Rerun install.ps1 to retry them."
} else {
    Write-Host "--> Latest runtimes installed"
}
