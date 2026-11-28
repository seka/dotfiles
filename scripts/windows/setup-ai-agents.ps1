$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "gh not found. Skipping AI agent skill installation."
    return
}

$Agents = @("github-copilot", "claude-code", "codex", "gemini-cli")
$Manifest = Join-Path $PSScriptRoot "..\resources\agent-skills.tsv"
foreach ($Line in (Get-Content -LiteralPath $Manifest)) {
    $Repository, $Skill = $Line -split "`t", 2
    foreach ($Agent in $Agents) {
        & gh skill install $Repository $Skill --agent $Agent --scope user --force
        if ($LASTEXITCODE -ne 0) {
            throw "Could not install $Skill from $Repository for $Agent."
        }
    }
}

$Npx = Get-Command npx -ErrorAction SilentlyContinue
foreach ($Repository in @("vercel-labs/agent-browser", "wheresryan22/anatomy")) {
    $SkillArguments = @()
    if ($Repository -eq "vercel-labs/agent-browser") {
        $SkillArguments = @("--skill", "agent-browser")
    }
    if ($Npx) {
        & $Npx --yes skills add $Repository @SkillArguments --global --agent @Agents --yes
    } else {
        & vfox exec nodejs@latest -- npx --yes skills add $Repository @SkillArguments --global --agent @Agents --yes
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Could not install skills from $Repository."
    }
}

& (Join-Path $PSScriptRoot "distribute-skills.ps1") -Source (Join-Path $HOME ".agents\skills") -Target antigravity

if (Get-Command crit -ErrorAction SilentlyContinue) {
    Push-Location -LiteralPath $HOME
    try {
        foreach ($Agent in @("github-copilot", "gemini", "codex-plugin")) {
            & crit install $Agent
            if ($LASTEXITCODE -ne 0) {
                Write-Host "crit $Agent install skipped or failed."
            }
        }
    } finally {
        Pop-Location
    }
}

if (Get-Command claude -ErrorAction SilentlyContinue) {
    & claude plugin marketplace add tomasz-tomczyk/crit
    if ($LASTEXITCODE -ne 0) {
        Write-Host "claude crit marketplace already exists or failed."
    }
    & claude plugin install crit@crit
    if ($LASTEXITCODE -ne 0) {
        Write-Host "claude crit plugin already installed or failed."
    }
}
