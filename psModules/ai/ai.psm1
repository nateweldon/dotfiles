# ── GitHub Models AI Module ──────────────────────────────────────────────────
# Requires: $env:GITHUB_TOKEN set to a GitHub Personal Access Token
# Models:   https://github.com/marketplace/models

$script:AI_ENDPOINT = "https://models.inference.ai.azure.com/chat/completions"
$script:AI_DEFAULT_MODEL = "gpt-4.1"

function Get-AIToken {
    if (-not $env:GITHUB_TOKEN) {
        Write-Host "  ✗ " -ForegroundColor Red -NoNewline
        Write-Host "GITHUB_TOKEN not set." -ForegroundColor DarkRed
        Write-Host "    Create one at: https://github.com/settings/tokens" -ForegroundColor DarkGray
        Write-Host "    Then run:  `$env:GITHUB_TOKEN = '<your-token>'" -ForegroundColor DarkGray
        Write-Host "    Or add it to your system env vars to persist across sessions." -ForegroundColor DarkGray
        return $null
    }
    return $env:GITHUB_TOKEN
}

function Invoke-AI {
    <#
    .SYNOPSIS
        Send a prompt to a GitHub Models AI and return the response.
    .EXAMPLE
        Invoke-AI "Explain what a monad is in one sentence."
        "What is PowerShell?" | Invoke-AI
    #>
    param(
        [Parameter(ValueFromPipeline=$true, Position=0)]
        [string]$Prompt,
        [string]$Model = $script:AI_DEFAULT_MODEL,
        [string]$SystemPrompt = "You are a helpful assistant.",
        [object[]]$History = @()
    )

    $token = Get-AIToken
    if (-not $token) { return }

    $messages = @()
    $messages += @{ role = "system"; content = $SystemPrompt }
    foreach ($h in $History) { $messages += $h }
    $messages += @{ role = "user"; content = $Prompt }

    $body = @{
        model    = $Model
        messages = $messages
    } | ConvertTo-Json -Depth 10

    try {
        $response = Invoke-RestMethod -Uri $script:AI_ENDPOINT `
            -Method Post `
            -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } `
            -Body $body `
            -ErrorAction Stop

        return $response.choices[0].message.content
    } catch {
        Write-Host "  ✗ AI request failed: " -ForegroundColor Red -NoNewline
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
        return $null
    }
}

function Ask-AI {
    <#
    .SYNOPSIS
        Ask the AI a question and print the response.
    .EXAMPLE
        Ask-AI "How do I reverse a string in PowerShell?"
        Ask-AI "Summarize this" -Model gpt-4o-mini
    #>
    param(
        [Parameter(ValueFromPipeline=$true, Position=0)]
        [string]$Prompt,
        [string]$Model = $script:AI_DEFAULT_MODEL
    )

    Write-Host ""
    Write-Host "  ◆ " -ForegroundColor Cyan -NoNewline
    Write-Host $Prompt -ForegroundColor DarkGray
    Write-Host ""

    $result = Invoke-AI -Prompt $Prompt -Model $Model
    if ($result) {
        Write-Host $result -ForegroundColor White
        Write-Host ""
    }
}

function Start-AIChat {
    <#
    .SYNOPSIS
        Start an interactive back-and-forth chat session with the AI.
    .EXAMPLE
        Start-AIChat
        Start-AIChat -Model gpt-4o-mini
        ai-chat
    #>
    param(
        [string]$Model = $script:AI_DEFAULT_MODEL,
        [string]$SystemPrompt = "You are a helpful assistant."
    )

    $token = Get-AIToken
    if (-not $token) { return }

    $history = @()

    Write-Host ""
    Write-Host "  ┌─ AI Chat (" -ForegroundColor DarkCyan -NoNewline
    Write-Host $Model -ForegroundColor Cyan -NoNewline
    Write-Host ") ─ type 'exit' to quit ──" -ForegroundColor DarkCyan
    Write-Host ""

    while ($true) {
        Write-Host "  You: " -ForegroundColor Green -NoNewline
        $input = Read-Host

        if ($input -eq "exit" -or $input -eq "quit" -or $input -eq "") { break }

        $result = Invoke-AI -Prompt $input -Model $Model -SystemPrompt $SystemPrompt -History $history
        if (-not $result) { break }

        $history += @{ role = "user";      content = $input  }
        $history += @{ role = "assistant"; content = $result }

        Write-Host ""
        Write-Host "  AI: " -ForegroundColor Cyan -NoNewline
        Write-Host $result -ForegroundColor White
        Write-Host ""
    }

    Write-Host "  └─ Chat ended ──────────────────────────────────" -ForegroundColor DarkCyan
    Write-Host ""
}

function Get-GitSummary {
    <#
    .SYNOPSIS
        Summarize local git changes using AI.
    .EXAMPLE
        Get-GitSummary
        Get-GitSummary -Staged
        Get-GitSummary -Model gpt-4o-mini
        git-ai
    #>
    param(
        [switch]$Staged,
        [string]$Model = $script:AI_DEFAULT_MODEL,
        [string]$Path = (Get-Location).Path
    )

    # Gather diff
    if ($Staged) {
        $diff = git -C $Path --no-pager diff --cached 2>&1
        $label = "staged"
    } else {
        $diff = git -C $Path --no-pager diff 2>&1
        $unstaged = $diff
        $stagedDiff = git -C $Path --no-pager diff --cached 2>&1
        $diff = @($unstaged, $stagedDiff) -join "`n"
        $label = "local"
    }

    $status = git -C $Path --no-pager status --short 2>&1

    if (-not $diff -and -not $status) {
        Write-Host "  No local changes found." -ForegroundColor DarkGray
        return
    }

    $content = "Git status:`n$status`n`nGit diff:`n$diff"

    if ($content.Length -gt 30000) {
        $content = $content.Substring(0, 30000) + "`n... (truncated)"
    }

    $systemPrompt = @"
You are a senior developer reviewing git changes. Summarize the changes clearly and concisely:
1. What changed (files and purpose)
2. Key additions or removals
3. Suggested commit message (conventional commits format)
Be brief. Use bullet points. No fluff.
"@

    Write-Host ""
    Write-Host "  ◆ Summarizing $label changes with " -ForegroundColor DarkGray -NoNewline
    Write-Host $Model -ForegroundColor Cyan -NoNewline
    Write-Host "..." -ForegroundColor DarkGray
    Write-Host ""

    $result = Invoke-AI -Prompt $content -Model $Model -SystemPrompt $systemPrompt
    if ($result) {
        Write-Host $result -ForegroundColor White
        Write-Host ""
    }
}

Set-Alias ask    Ask-AI
Set-Alias ai-chat Start-AIChat
Set-Alias git-ai  Get-GitSummary

Export-ModuleMember -Function Invoke-AI, Ask-AI, Start-AIChat, Get-GitSummary -Alias ask, ai-chat, git-ai
