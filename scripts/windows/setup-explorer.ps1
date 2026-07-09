$ErrorActionPreference = "Stop"

Write-Host "==> Configuring Explorer preferences"

$ExplorerAdvancedPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
New-Item -Path $ExplorerAdvancedPath -Force | Out-Null

Set-ItemProperty -Path $ExplorerAdvancedPath -Name "Hidden" -Type DWord -Value 1
Set-ItemProperty -Path $ExplorerAdvancedPath -Name "HideFileExt" -Type DWord -Value 0

Write-Host "--> Explorer preferences configured"
Write-Host "Open a new Explorer window if hidden files or extensions are not visible yet."
