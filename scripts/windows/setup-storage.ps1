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
    GoBin = Join-Path $DataDrive "dev\go\bin"
    GoModuleCache = Join-Path $DataDrive "dev\go\pkg\mod"
    Vfox = Join-Path $DataDrive "dev\vfox"
    NodeGlobal = Join-Path $DataDrive "dev\node-global"
    Rust = Join-Path $DataDrive "dev\rust"
    Cargo = Join-Path $DataDrive "dev\rust\cargo"
    Rustup = Join-Path $DataDrive "dev\rust\rustup"
    Build = Join-Path $DataDrive "build"
    Caches = Join-Path $DataDrive "caches"
    CargoTarget = Join-Path $DataDrive "caches\cargo-target"
    GoBuildCache = Join-Path $DataDrive "caches\go-build"
    NpmCache = Join-Path $DataDrive "caches\npm"
    PipCache = Join-Path $DataDrive "caches\pip"
    UvCache = Join-Path $DataDrive "caches\uv"
    Containers = Join-Path $DataDrive "containers"
    Docker = Join-Path $DataDrive "containers\docker"
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
Set-UserEnvironmentVariable -Name "GOBIN" -Value $Paths.GoBin
Set-UserEnvironmentVariable -Name "GOMODCACHE" -Value $Paths.GoModuleCache
Set-UserEnvironmentVariable -Name "GOCACHE" -Value $Paths.GoBuildCache
Set-UserEnvironmentVariable -Name "CARGO_HOME" -Value $Paths.Cargo
Set-UserEnvironmentVariable -Name "RUSTUP_HOME" -Value $Paths.Rustup
Set-UserEnvironmentVariable -Name "CARGO_TARGET_DIR" -Value $Paths.CargoTarget
Set-UserEnvironmentVariable -Name "PIP_CACHE_DIR" -Value $Paths.PipCache
Set-UserEnvironmentVariable -Name "UV_CACHE_DIR" -Value $Paths.UvCache

$LegacyVfoxHome = [Environment]::GetEnvironmentVariable("VFOX_HOME", "User")
if ($LegacyVfoxHome) {
    [Environment]::SetEnvironmentVariable("VFOX_HOME", $null, "User")
}
Remove-Item Env:VFOX_HOME -ErrorAction SilentlyContinue

if (Get-Command vfox -ErrorAction SilentlyContinue) {
    & vfox config storage.sdkPath $Paths.Vfox
    if ($LASTEXITCODE -ne 0) {
        throw "Could not configure the vfox SDK storage path."
    }
}

$CargoBin = Join-Path $Paths.Cargo "bin"
$LegacyCargoBin = Join-Path $HOME ".cargo\bin"
$LegacyNpmRoot = Join-Path $env:APPDATA "npm"
$LegacyGoBin = Join-Path $HOME "go\bin"
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
$UserPathEntries = @(
    $UserPath -split ";" |
        Where-Object {
            $_ -and
            $_.TrimEnd("\") -ine $LegacyCargoBin.TrimEnd("\") -and
            $_.TrimEnd("\") -ine $LegacyNpmRoot.TrimEnd("\") -and
            $_.TrimEnd("\") -ine $LegacyGoBin.TrimEnd("\")
        }
)
$RequiredUserPaths = @($CargoBin, $Paths.NodeGlobal, $Paths.GoBin)
$UserPathEntries = @($RequiredUserPaths + $UserPathEntries)
[Environment]::SetEnvironmentVariable(
    "Path",
    (($UserPathEntries | Select-Object -Unique) -join ";"),
    "User"
)

if (Get-Command npm -ErrorAction SilentlyContinue) {
    & npm config set prefix $Paths.NodeGlobal --location=user
    if ($LASTEXITCODE -ne 0) {
        throw "Could not configure the npm global prefix."
    }
    & npm config set cache $Paths.NpmCache --location=user
    if ($LASTEXITCODE -ne 0) {
        throw "Could not configure the npm cache."
    }
}

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
Write-Host ("    GOCACHE:  " + $Paths.GoBuildCache)
Write-Host ("    vfox SDKs:" + $Paths.Vfox)
Write-Host ("    npm root: " + $Paths.NodeGlobal)
Write-Host ("    Cargo:    " + $Paths.Cargo)
Write-Host ("    Rustup:   " + $Paths.Rustup)
Write-Host ("    Caches:   " + $Paths.Caches)
Write-Host ("    Hyper-V:  " + $Paths.HyperV)
Write-Host ("    Docker:   " + $Paths.Docker)
