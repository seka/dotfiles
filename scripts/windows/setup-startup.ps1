$ErrorActionPreference = "Stop"

$StartupItems = @(
    @{
        Name = "Docker Desktop"
        Patterns = @(
            "Docker Desktop"
            "DockerDesktop"
            "com.docker.docker"
        )
    }
    @{
        Name = "Slack"
        Patterns = @(
            "Slack"
        )
    }
    @{
        Name = "Microsoft Teams"
        Patterns = @(
            "Microsoft Teams"
            "Teams"
            "ms-teams"
        )
    }
    @{
        Name = "Dropbox"
        Patterns = @(
            "Dropbox"
        )
    }
)

function Test-StartupMatch {
    param(
        [string]$Name,
        [string]$Value,
        [string[]]$Patterns
    )

    foreach ($Pattern in $Patterns) {
        if ($Name -like "*$Pattern*" -or $Value -like "*$Pattern*") {
            return $true
        }
    }

    return $false
}

function Remove-StartupRegistryValue {
    param(
        [string]$RegistryPath,
        [hashtable]$StartupItem
    )

    if (-not (Test-Path $RegistryPath)) {
        return
    }

    $Properties = Get-ItemProperty -Path $RegistryPath
    foreach ($Property in $Properties.PSObject.Properties) {
        if ($Property.Name -like "PS*") {
            continue
        }

        if (Test-StartupMatch -Name $Property.Name -Value ([string]$Property.Value) -Patterns $StartupItem.Patterns) {
            try {
                Remove-ItemProperty -Path $RegistryPath -Name $Property.Name -ErrorAction Stop
                Write-Host ("Removed startup registry entry: " + $StartupItem.Name + " (" + $Property.Name + ")")
            } catch {
                Write-Host ("Could not remove startup registry entry: " + $StartupItem.Name + " (" + $Property.Name + ")")
                Write-Host ("  " + $_.Exception.Message)
            }
        }
    }
}

function Remove-StartupShortcut {
    param(
        [string]$StartupDirectory,
        [hashtable]$StartupItem
    )

    if (-not (Test-Path $StartupDirectory)) {
        return
    }

    Get-ChildItem -Path $StartupDirectory -File -ErrorAction SilentlyContinue |
        Where-Object {
            Test-StartupMatch -Name $_.BaseName -Value $_.FullName -Patterns $StartupItem.Patterns
        } |
        ForEach-Object {
            try {
                Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
                Write-Host ("Removed startup shortcut: " + $StartupItem.Name + " (" + $_.Name + ")")
            } catch {
                Write-Host ("Could not remove startup shortcut: " + $StartupItem.Name + " (" + $_.Name + ")")
                Write-Host ("  " + $_.Exception.Message)
            }
        }
}

Write-Host "==> Disabling unnecessary startup apps"

$RegistryPaths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)

$StartupDirectories = @(
    [Environment]::GetFolderPath("Startup")
    [Environment]::GetFolderPath("CommonStartup")
)

foreach ($StartupItem in $StartupItems) {
    foreach ($RegistryPath in $RegistryPaths) {
        Remove-StartupRegistryValue -RegistryPath $RegistryPath -StartupItem $StartupItem
    }

    foreach ($StartupDirectory in $StartupDirectories) {
        Remove-StartupShortcut -StartupDirectory $StartupDirectory -StartupItem $StartupItem
    }
}

Write-Host "--> Startup apps configured"
