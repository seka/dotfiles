$ErrorActionPreference = "Stop"

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    throw "uv was not found. Install uv with winget and rerun setup-python-tools.ps1."
}

Write-Host "==> Installing Python tools"
# Pythonの導入元をuvに統一するため、安定版と既定の実行リンクを作成する。
& uv python install --default
if ($LASTEXITCODE -ne 0) {
    throw "Python installation failed."
}

# 各ツールの実行環境を独立して管理するため、専用の仮想環境にuv管理のPythonで導入する。
$Tools = @("pynvim", "codespell", "ruff")
foreach ($Tool in $Tools) {
    & uv tool install --managed-python $Tool
    if ($LASTEXITCODE -ne 0) {
        throw "$Tool installation failed."
    }
}

# Neovimなどから実行ファイルを検出できるよう、uvの配置先をユーザーPATHに登録する。
& uv tool update-shell
if ($LASTEXITCODE -ne 0) {
    throw "Could not add uv tools to PATH."
}

Write-Host "--> Python tools installed"
