$ErrorActionPreference = "Stop"

$DotfilesRoot = Join-Path $PSScriptRoot "..\.."
$GitConfigDir = Join-Path $HOME ".config\git"
New-Item -ItemType Directory -Force -Path $GitConfigDir | Out-Null
Copy-Item -LiteralPath (Join-Path $DotfilesRoot "git\config") -Destination (Join-Path $GitConfigDir "config") -Force
Copy-Item -LiteralPath (Join-Path $DotfilesRoot "git\ignore") -Destination (Join-Path $GitConfigDir "ignore") -Force
Copy-Item -LiteralPath (Join-Path $DotfilesRoot "terminal\tigrc") -Destination (Join-Path $HOME ".tigrc") -Force
