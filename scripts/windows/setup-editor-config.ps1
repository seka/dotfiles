$ErrorActionPreference = "Stop"

$DotfilesRoot = Join-Path $PSScriptRoot "..\.."
$NeovimConfigRoot = $env:XDG_CONFIG_HOME
if (-not $NeovimConfigRoot) {
    $NeovimConfigRoot = $env:LOCALAPPDATA
}
$NeovimApp = $env:NVIM_APPNAME
if (-not $NeovimApp) {
    $NeovimApp = "nvim"
}

$NeovimConfig = Join-Path $NeovimConfigRoot $NeovimApp
New-Item -ItemType Directory -Force -Path $NeovimConfig | Out-Null
Get-ChildItem -LiteralPath (Join-Path $DotfilesRoot "editors\vim\nvim") -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $NeovimConfig -Recurse -Force
}

$VSCodeConfig = Join-Path $env:APPDATA "Code\User"
New-Item -ItemType Directory -Force -Path $VSCodeConfig | Out-Null
foreach ($Name in @("settings.json", "keybindings.json")) {
    $Source = Join-Path $DotfilesRoot "editors\vscode\$Name"
    Copy-Item -LiteralPath $Source -Destination (Join-Path $VSCodeConfig $Name) -Force
}

$Code = Get-Command code -ErrorAction SilentlyContinue
$Extensions = Join-Path $DotfilesRoot "editors\vscode\extensions.txt"
if ($Code -and (Test-Path -LiteralPath $Extensions)) {
    foreach ($Extension in (Get-Content -LiteralPath $Extensions)) {
        if ($Extension -and -not $Extension.StartsWith("#")) {
            & $Code --install-extension $Extension --force
            if ($LASTEXITCODE -ne 0) {
                Write-Host "VS Code extension install failed: $Extension"
            }
        }
    }
} else {
    Write-Host "VS Code CLI 'code' was not found. Skipping extension install."
}
