param(
    [string[]]$Source = (Join-Path $PSScriptRoot "..\..\ai-agents\skills"),
    [ValidateSet("claude", "codex", "gemini", "antigravity", "copilot")]
    [string[]]$Target,
    [string[]]$Skill,
    [string]$Export,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
if ($Export -and $Target) {
    throw "-Export and -Target cannot be used together."
}
if (-not $Target) {
    $Target = @("claude", "codex", "gemini", "antigravity", "copilot")
}

$Skills = @{}
foreach ($SourceDirectory in $Source) {
    if (-not (Test-Path -LiteralPath $SourceDirectory -PathType Container)) {
        throw "Skill source is not a directory: $SourceDirectory"
    }
    foreach ($Entry in (Get-ChildItem -LiteralPath $SourceDirectory -Force)) {
        if ($Entry.PSIsContainer) {
            $Name = $Entry.Name
            $SkillFile = Join-Path $Entry.FullName "SKILL.md"
        } elseif ($Entry.Extension -ceq ".md") {
            $Name = $Entry.BaseName
            $SkillFile = $Entry.FullName
        } else {
            continue
        }
        if (-not (Test-Path -LiteralPath $SkillFile -PathType Leaf)) {
            continue
        }
        if ($Skill -and $Name -cnotin $Skill) {
            continue
        }
        if ($Name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$' -or $Skills.ContainsKey($Name)) {
            throw "Invalid or duplicate skill name: $Name"
        }

        $FrontMatter = [regex]::Match([IO.File]::ReadAllText($SkillFile), '\A---\r?\n(?<Fields>.*?)\r?\n---(?:\r?\n|\z)', 'Singleline')
        if (-not $FrontMatter.Success -or $FrontMatter.Groups["Fields"].Value -cnotmatch "(?m)^name:[ \t]*$Name\r?$") {
            throw "Skill front matter does not match the file name: $SkillFile"
        }
        $Skills[$Name] = $Entry
    }
}
foreach ($Name in $Skill) {
    if (-not $Skills.ContainsKey($Name)) {
        throw "Skill not found: $Name"
    }
}
if ($Skills.Count -eq 0) {
    throw "No skills found in $Source"
}

# Match the Bash distributor's preflight so a collision does not leave a partially copied set.
$Destinations = if ($Export) {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Export)
} else {
    foreach ($Agent in ($Target | Select-Object -Unique)) {
        if ($Agent -eq "antigravity") {
            Join-Path $HOME ".gemini\antigravity-cli\skills"
        } else {
            Join-Path $HOME ".$Agent\skills"
        }
    }
}

$Copies = foreach ($Destination in $Destinations) {
    $Destination = [IO.Path]::GetFullPath($Destination)
    if ([IO.Path]::GetPathRoot($Destination) -ne $Destination) {
        $Destination = $Destination.TrimEnd([IO.Path]::DirectorySeparatorChar)
    }
    foreach ($Name in ($Skills.Keys | Sort-Object)) {
        $Entry = $Skills[$Name]
        $SkillDestination = Join-Path $Destination $Name
        if ($Entry.PSIsContainer) {
            $Files = Get-ChildItem -LiteralPath $Entry.FullName -File -Recurse -Force
        } else {
            $Files = $Entry
        }
        foreach ($File in $Files) {
            $RelativePath = "SKILL.md"
            if ($Entry.PSIsContainer) {
                $RelativePath = $File.FullName.Substring($Entry.FullName.Length + 1)
            }
            $FileDestination = Join-Path $SkillDestination $RelativePath
            $Existing = Get-Item -LiteralPath $FileDestination -Force -ErrorAction SilentlyContinue
            if ($Existing) {
                if (-not $Existing.PSIsContainer -and -not ($Existing.Attributes -band [IO.FileAttributes]::ReparsePoint) -and
                    $Existing.Length -eq $File.Length -and
                    (Get-FileHash -LiteralPath $Existing.FullName).Hash -eq (Get-FileHash -LiteralPath $File.FullName).Hash) {
                    continue
                }
                throw "Skill file already exists with different content: $FileDestination"
            }
            $Parent = Split-Path -Parent $FileDestination
            while ($Parent -ne $Destination) {
                $ExistingParent = Get-Item -LiteralPath $Parent -Force -ErrorAction SilentlyContinue
                if ($ExistingParent -and (-not $ExistingParent.PSIsContainer -or
                    ($ExistingParent.Attributes -band [IO.FileAttributes]::ReparsePoint))) {
                    throw "Skill destination parent is a link or a file: $Parent"
                }
                $Parent = Split-Path -Parent $Parent
            }
            [pscustomobject]@{ Source = $File.FullName; Target = $FileDestination }
        }
    }
}

foreach ($Copy in $Copies) {
    if (-not $DryRun) {
        [IO.Directory]::CreateDirectory((Split-Path -Parent $Copy.Target)) | Out-Null
        [IO.File]::Copy($Copy.Source, $Copy.Target)
    }
    Write-Host "COPY $($Copy.Source) -> $($Copy.Target)"
}
