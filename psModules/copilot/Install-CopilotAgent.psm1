function Install-CopilotAgent {
<#
.SYNOPSIS
    Symlinks one or more agents from the awesome-copilot or custom agents repo into ~/.copilot/agents/

.DESCRIPTION
    Creates symbolic links in ~/.copilot/agents/ pointing to .agent.md files from the
    awesome-copilot community repo or your custom aiAgents repo.
    Agent names can be provided with or without the .agent.md extension.
    Supports tab completion and wildcards.

    Requires PowerShell to be run as Administrator for symlink creation.

.PARAMETER Name
    One or more agent names. The .agent.md extension is optional.
    Supports wildcards (e.g. "azure-*", "*react*").

.PARAMETER Path
    Path to a repo root. When provided, agents are symlinked into
    <Path>\.copilot\agents\ instead of the global ~/.copilot/agents/.
    Defaults to the global location when omitted.

.PARAMETER Source
    Which agent source to use: community, custom, or all.
    - community: awesome-copilot repo (default)
    - custom:    your aiAgents repo
    - all:       both repos

.PARAMETER List
    Lists all available agents from the selected source.

.PARAMETER Search
    Search agents by name or description. Returns matching agents with their descriptions.

.PARAMETER Describe
    Show the full description and metadata for one or more agents.

.PARAMETER Update
    Git pull the selected source repo(s) to fetch the latest agents.

.EXAMPLE
    Install-CopilotAgent CSharpExpert
    Install-CopilotAgent azure-principal-architect expert-react-frontend-engineer
    Install-CopilotAgent azure-*
    Install-CopilotAgent -List
    ica CSharpExpert
    ica -List
    # Install into a specific repo
    ica CSharpExpert -Path C:\Users\nweldon\workspace\repos\myProject
    ica -List -Path .
    # Search for agents by keyword
    ica -Search react
    ica -Search "azure*"
    # Show agent details
    ica -Describe CSharpExpert
    # Pull latest agents from GitHub
    ica -Update
    # Work with custom agents
    ica -List -Source custom
    ica -Search "code review" -Source custom
    ica csharp-code-reviewer -Source custom
    ica csharp-code-reviewer -Source custom -Path C:\myRepo
    # Search across both sources
    ica -Search csharp -Source all
    ica -List -Source all
#>
    [CmdletBinding(DefaultParameterSetName = 'Install')]
    param(
        [Parameter(ParameterSetName = 'Install', Position = 0, Mandatory, ValueFromRemainingArguments)]
        [string[]]$Name,

        [Parameter(ParameterSetName = 'List')]
        [switch]$List,

        [Parameter(ParameterSetName = 'Search', Mandatory)]
        [string]$Search,

        [Parameter(ParameterSetName = 'Describe', Mandatory)]
        [string[]]$Describe,

        [Parameter(ParameterSetName = 'Update')]
        [switch]$Update,

        [Parameter()]
        [ValidateSet('community', 'custom', 'all')]
        [string]$Source = 'community',

        [Parameter()]
        [string]$Path
    )

    # Agent source directories
    $Sources = @{
        community = @{
            AgentDir = "C:\Users\nweldon\workspace\repos\awesome-copilot\agents"
            RepoDir  = "C:\Users\nweldon\workspace\repos\awesome-copilot"
            Label    = "community"
            Pattern  = "*.agent.md"
        }
        custom = @{
            AgentDir = "C:\Users\nweldon\workspace\repos\aiAgents\.github\agents"
            RepoDir  = "C:\Users\nweldon\workspace\repos\aiAgents"
            Label    = "custom"
            Pattern  = "*.md"
        }
    }

    # Resolve which sources to use
    $activeSources = if ($Source -eq 'all') { $Sources.Values } else { @($Sources[$Source]) }

    # Validate source directories exist
    foreach ($src in $activeSources) {
        if (-not (Test-Path $src.AgentDir)) {
            Write-Error "$($src.Label) agents not found at: $($src.AgentDir)"
            return
        }
    }

    # Resolve target directory
    if ($Path) {
        $resolvedPath = Resolve-Path -Path $Path -ErrorAction SilentlyContinue
        if (-not $resolvedPath) {
            Write-Error "Path not found: $Path"
            return
        }
        $TargetDir = Join-Path $resolvedPath.Path ".copilot\agents"
        Write-Host "Targeting repo: $($resolvedPath.Path)" -ForegroundColor Cyan
    } else {
        $TargetDir = "$HOME\.copilot\agents"
    }

    # Helper: parse YAML frontmatter from an agent file
    function Get-AgentMeta {
        param(
            [System.IO.FileInfo]$File,
            [string]$SourceLabel
        )
        $lines = Get-Content $File.FullName -TotalCount 30
        $inFrontmatter = $false
        $meta = @{ Name = ''; Description = ''; Model = ''; File = $File; Source = $SourceLabel }
        foreach ($line in $lines) {
            if ($line -match '^---\s*$' -and -not $inFrontmatter) { $inFrontmatter = $true; continue }
            if ($line -match '^---\s*$' -and $inFrontmatter) { break }
            if ($inFrontmatter) {
                if ($line -match "^description:\s*['""]?(.+?)['""]?\s*$") { $meta.Description = $Matches[1] }
                if ($line -match "^name:\s*['""]?(.+?)['""]?\s*$")        { $meta.Name = $Matches[1] }
                if ($line -match "^model:\s*['""]?(.+?)['""]?\s*$")       { $meta.Model = $Matches[1] }
            }
        }
        if (-not $meta.Name) { $meta.Name = $File.BaseName -replace '\.agent$','' }
        $meta
    }

    # Helper: get all agent files from active sources
    function Get-AllAgentFiles {
        $allFiles = @()
        foreach ($src in $activeSources) {
            $files = Get-ChildItem "$($src.AgentDir)\$($src.Pattern)" -File
            foreach ($f in $files) {
                $allFiles += @{ File = $f; Source = $src.Label }
            }
        }
        $allFiles
    }

    # Helper: normalize agent filename to a short display name
    function Get-AgentShortName {
        param([System.IO.FileInfo]$File)
        $File.BaseName -replace '\.agent$',''
    }

    # Helper: get the canonical link name (ensure .agent.md for symlink target)
    function Get-AgentLinkName {
        param([System.IO.FileInfo]$File)
        if ($File.Name -match '\.agent\.md$') { return $File.Name }
        # Custom agents may be just .md — link as-is
        return $File.Name
    }

    # -Update mode: git pull the source repo(s)
    if ($Update) {
        foreach ($src in $activeSources) {
            Write-Host "Updating $($src.Label) repo..." -ForegroundColor Cyan
            Push-Location $src.RepoDir
            try {
                $before = (Get-ChildItem "$($src.AgentDir)\$($src.Pattern)" -File).Count
                git pull
                $after = (Get-ChildItem "$($src.AgentDir)\$($src.Pattern)" -File).Count
                Write-Host "Done ($($src.Label)). Agents: $before -> $after" -ForegroundColor Green
            } finally {
                Pop-Location
            }
        }
        return
    }

    # -Search mode: find agents by name or description
    if ($Search) {
        $allAgentFiles = Get-AllAgentFiles
        $results = @()
        foreach ($entry in $allAgentFiles) {
            $meta = Get-AgentMeta -File $entry.File -SourceLabel $entry.Source
            $shortName = Get-AgentShortName -File $entry.File
            if ($shortName -like "*$Search*" -or $meta.Name -like "*$Search*" -or $meta.Description -like "*$Search*") {
                $results += $meta
            }
        }

        if (-not $results) {
            Write-Warning "No agents found matching: $Search"
            return
        }

        foreach ($r in $results | Sort-Object { $_.Source }, { $_.File.BaseName }) {
            $shortName = Get-AgentShortName -File $r.File
            $linkName  = Get-AgentLinkName -File $r.File
            $isLinked  = Test-Path "$TargetDir\$linkName"
            $prefix    = if ($isLinked) { "[linked] " } else { "         " }
            $nameColor = if ($isLinked) { "Green" } else { "White" }
            $srcTag    = if ($activeSources.Count -gt 1) { " [$($r.Source)]" } else { "" }
            Write-Host "$prefix$shortName" -ForegroundColor $nameColor -NoNewline
            if ($r.Model) { Write-Host " ($($r.Model))" -ForegroundColor DarkGray -NoNewline }
            if ($srcTag)  { Write-Host $srcTag -ForegroundColor DarkYellow -NoNewline }
            Write-Host ""
            if ($r.Description) { Write-Host "           $($r.Description)" -ForegroundColor Gray }
        }
        Write-Host "`n$($results.Count) agent(s) found." -ForegroundColor Cyan
        return
    }

    # -Describe mode: show details for specific agents
    if ($Describe) {
        $allAgentFiles = Get-AllAgentFiles
        foreach ($d in $Describe) {
            $baseName = $d -replace '\.agent\.md$','' -replace '\.agent$','' -replace '\.md$',''
            $descMatches = $allAgentFiles | Where-Object {
                (Get-AgentShortName -File $_.File) -like $baseName
            }
            if (-not $descMatches) {
                Write-Warning "No agent found matching: $d"
                continue
            }
            foreach ($entry in $descMatches) {
                $meta = Get-AgentMeta -File $entry.File -SourceLabel $entry.Source
                $shortName = Get-AgentShortName -File $entry.File
                $linkName  = Get-AgentLinkName -File $entry.File
                $isLinked  = Test-Path "$TargetDir\$linkName"

                Write-Host "`n  $($meta.Name)" -ForegroundColor Cyan
                Write-Host "  File:        $($entry.File.Name)" -ForegroundColor Gray
                Write-Host "  Source:      $($entry.Source)" -ForegroundColor Gray
                if ($meta.Model)       { Write-Host "  Model:       $($meta.Model)" -ForegroundColor Gray }
                if ($meta.Description) { Write-Host "  Description: $($meta.Description)" -ForegroundColor White }
                $linkStatus = if ($isLinked) { "Yes" } else { "No" }
                $linkColor  = if ($isLinked) { "Green" } else { "Yellow" }
                Write-Host "  Linked:      $linkStatus" -ForegroundColor $linkColor
                Write-Host ""
            }
        }
        return
    }

    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
        Write-Host "Created directory: $TargetDir" -ForegroundColor Green
    }

    # -List mode: show all available agents from selected source(s)
    if ($List) {
        foreach ($src in $activeSources) {
            if ($activeSources.Count -gt 1) {
                Write-Host "`n  === $($src.Label) ===" -ForegroundColor Cyan
            }
            Get-ChildItem "$($src.AgentDir)\$($src.Pattern)" -File | Sort-Object Name | ForEach-Object {
                $linkName = Get-AgentLinkName -File $_
                $linked = Test-Path "$TargetDir\$linkName"
                $status = if ($linked) { "[linked] " } else { "         " }
                $color  = if ($linked) { "Green"    } else { "Gray"    }
                Write-Host "$status$(Get-AgentShortName -File $_)" -ForegroundColor $color
            }
        }
        return
    }

    # Install mode: symlink each requested agent
    $allAgentFiles = Get-AllAgentFiles
    foreach ($n in $Name) {
        # Normalize: strip .agent.md or .agent or .md if provided
        $baseName = $n -replace '\.agent\.md$','' -replace '\.agent$','' -replace '\.md$',''

        # Resolve wildcard matches across active sources
        $agentMatches = $allAgentFiles | Where-Object {
            (Get-AgentShortName -File $_.File) -like $baseName
        }

        if (-not $agentMatches) {
            Write-Warning "No agent found matching: $n"
            continue
        }

        foreach ($entry in $agentMatches) {
            $linkName = Get-AgentLinkName -File $entry.File
            $linkPath = Join-Path $TargetDir $linkName

            if (Test-Path $linkPath) {
                Write-Host "Already linked: $linkName" -ForegroundColor Yellow
                continue
            }

            try {
                New-Item -ItemType SymbolicLink -Path $linkPath -Target $entry.File.FullName -ErrorAction Stop | Out-Null
                Write-Host "Linked: $linkName [$($entry.Source)]" -ForegroundColor Green
            } catch [System.UnauthorizedAccessException] {
                Write-Error "Symlink creation requires Administrator privileges. Re-run PowerShell as Administrator."
                return
            } catch {
                Write-Error "Failed to link $($linkName): $_"
            }
        }
    }
}
Set-Alias -Name ica -Value Install-CopilotAgent -Description "Install copilot agent(s) from awesome-copilot or custom repo"
