param(
    [string]$DataDrive = $(if ($env:DOTFILES_DATA_DRIVE) { $env:DOTFILES_DATA_DRIVE } else { "D:\" })
)

$ErrorActionPreference = "Stop"

$DataDrive = [System.IO.Path]::GetFullPath($DataDrive)
$DataDriveRoot = [System.IO.Path]::GetPathRoot($DataDrive)

if (-not (Test-Path -LiteralPath $DataDriveRoot)) {
    Write-Host "Development data drive was not found: $DataDriveRoot"
    Write-Host "Set DOTFILES_DATA_DRIVE to an existing drive and rerun install.ps1."
    return
}

$Paths = @{
    Development = Join-Path $DataDrive "dev"
    Repositories = Join-Path $DataDrive "dev\ghq"
    Go = Join-Path $DataDrive "dev\go"
    Vfox = Join-Path $DataDrive "dev\vfox"
    Build = Join-Path $DataDrive "build"
    Containers = Join-Path $DataDrive "containers"
    HyperV = Join-Path $DataDrive "Hyper-V"
    Iso = Join-Path $DataDrive "iso"
}

foreach ($Path in $Paths.Values) {
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Set-UserEnvironmentVariable {
    param(
        [string]$Name,
        [string]$Value
    )

    $CurrentValue = [Environment]::GetEnvironmentVariable($Name, "User")
    if ($CurrentValue -ne $Value) {
        [Environment]::SetEnvironmentVariable($Name, $Value, "User")
    }

    Set-Item -Path "Env:$Name" -Value $Value
}

Set-UserEnvironmentVariable -Name "DOTFILES_DATA_DRIVE" -Value $DataDrive
Set-UserEnvironmentVariable -Name "GOPATH" -Value $Paths.Go
Set-UserEnvironmentVariable -Name "VFOX_HOME" -Value $Paths.Vfox

if (Get-Command git -ErrorAction SilentlyContinue) {
    $CurrentGhqRoot = & git config --global --get ghq.root
    if ($LASTEXITCODE -ne 0 -or $CurrentGhqRoot -ne $Paths.Repositories) {
        & git config --global ghq.root $Paths.Repositories
        if ($LASTEXITCODE -ne 0) {
            throw "Could not configure ghq.root."
        }
    }
} else {
    Write-Host "git was not found. Skipping ghq.root configuration."
}

$IsAdministrator = (
    [Security.Principal.WindowsPrincipal](
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ((Get-Command Set-VMHost -ErrorAction SilentlyContinue) -and $IsAdministrator) {
    $VMHost = Get-VMHost
    if (
        $VMHost.VirtualHardDiskPath -ne $Paths.HyperV -or
        $VMHost.VirtualMachinePath -ne $Paths.HyperV
    ) {
        Set-VMHost `
            -VirtualHardDiskPath $Paths.HyperV `
            -VirtualMachinePath $Paths.HyperV
    }
} elseif (Get-Command Get-VMHost -ErrorAction SilentlyContinue) {
    Write-Host "Run install.ps1 as administrator to configure Hyper-V default paths."
}

Write-Host "--> Development storage configured"
Write-Host ("    ghq.root: " + $Paths.Repositories)
Write-Host ("    GOPATH:   " + $Paths.Go)
Write-Host ("    VFOX_HOME:" + $Paths.Vfox)
Write-Host ("    Hyper-V:  " + $Paths.HyperV)
Write-Host ("    Docker:   " + $Paths.Containers)
