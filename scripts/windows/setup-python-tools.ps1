$ErrorActionPreference = "Stop"

if (-not (Get-Command vfox -ErrorAction SilentlyContinue)) {
    Write-Host "vfox was not found. Skipping Python tool setup."
    exit 0
}

Write-Host "==> Installing Python tools"
$CurrentPython = (& vfox current python | Out-String)
$PythonVersionMatch = [regex]::Match($CurrentPython, '\d+\.\d+\.\d+')
if (-not $PythonVersionMatch.Success) {
    Write-Host "No active vfox Python version was found. Skipping Python tools."
    exit 0
}

$PythonSdk = "python@$($PythonVersionMatch.Value)"
$PythonRoot = (& vfox info --format "{{.Path}}" $PythonSdk | Out-String).Trim()
$PythonExecutable = Get-ChildItem -Path $PythonRoot -Recurse -Filter python.exe -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

if (-not $PythonExecutable) {
    Write-Host "The vfox Python executable was not found. Skipping Python tools."
    exit 0
}

& $PythonExecutable -m pip install --user pipx
if ($LASTEXITCODE -ne 0) {
    Write-Host "pipx installation failed. Skipping Python tools."
    exit 0
}

$Tools = @("pynvim", "codespell")
foreach ($Tool in $Tools) {
    & $PythonExecutable -m pipx install $Tool
    if ($LASTEXITCODE -ne 0) {
        Write-Host "$Tool installation failed. Continuing."
    }
}

Write-Host "--> Python tools installed"
