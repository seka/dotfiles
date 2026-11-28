$ErrorActionPreference = "Stop"

$AgentConfig = Join-Path $PSScriptRoot "..\..\ai-agents"
$AgentInstructions = Join-Path $AgentConfig "AGENTS.md"

function Copy-ConfigFile($Source, $Target) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Target) | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Target -Force
}

Copy-ConfigFile $AgentInstructions (Join-Path $HOME ".claude\CLAUDE.md")
Copy-ConfigFile (Join-Path $AgentConfig "claude\settings.json") (Join-Path $HOME ".claude\settings.json")
Get-ChildItem -LiteralPath (Join-Path $AgentConfig "skills") -Filter "*.md" -File | ForEach-Object {
    Copy-ConfigFile $_.FullName (Join-Path $HOME ".claude\commands\$($_.Name)")
}

Copy-ConfigFile $AgentInstructions (Join-Path $HOME ".gemini\AGENTS.md")
Copy-ConfigFile (Join-Path $AgentConfig "gemini\settings.json") (Join-Path $HOME ".gemini\settings.json")
$GeminiInstructions = Join-Path $HOME ".gemini\GEMINI.md"
if (Get-Item -LiteralPath $GeminiInstructions -Force -ErrorAction SilentlyContinue) {
    Write-Host "Existing ~/.gemini/GEMINI.md preserved; review Web search instructions there manually."
} else {
    Copy-ConfigFile $AgentInstructions $GeminiInstructions
}

if (-not $env:LOCALAPPDATA) {
    throw "LOCALAPPDATA is required to render Windows Codex paths."
}
$CodexConfig = Join-Path $HOME ".codex\config.toml"
Copy-ConfigFile $AgentInstructions (Join-Path $HOME ".codex\AGENTS.md")
$Template = [IO.File]::ReadAllText((Join-Path $AgentConfig "codex\config.windows.toml.template")) + "`n" +
    [IO.File]::ReadAllText((Join-Path $AgentConfig "codex\config.toml.template"))
$CodexResources = $env:LOCALAPPDATA.Replace('\', '/').Replace('"', '\"') + "/Programs/Codex/resources"
$Paths = @{
    HOME = $HOME.Replace('\', '/').Replace('"', '\"')
    NODE_REPL_COMMAND = "node_repl.cmd"
    NODE_REPL_MODULES = "$CodexResources/cua_node/lib/node_modules"
    NODE_REPL_NODE = "$CodexResources/cua_node/bin/node.exe"
    CODEX_CLI_PATH = "$CodexResources/codex.exe"
}
$Config = [regex]::Replace($Template, '\{\{([A-Z_]+)\}\}', {
    param($Match)
    $Paths[$Match.Groups[1].Value]
})
[IO.File]::WriteAllText($CodexConfig, $Config, [Text.UTF8Encoding]::new($false))

Copy-ConfigFile (Join-Path $AgentConfig "agent-browser\config.json") (Join-Path $HOME ".agent-browser\config.json")
& (Join-Path $PSScriptRoot "distribute-skills.ps1")
