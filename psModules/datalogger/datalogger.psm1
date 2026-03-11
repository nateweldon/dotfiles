

function StartEnd {
<#
.SYNOPSIS
    Registers a session-exit hook that appends commands to a daily Markdown history file.

.DESCRIPTION
    On PowerShell exit, appends every command from the session to a Markdown file
    named by date (e.g. 2026-03-09.md) under ~/workspace/history/. If the file
    already exists (from an earlier session that day), the new session is appended
    as a new section. Each session records the time window and a table of commands.
#>
    $historyPath = "$env:USERPROFILE\workspace\history"
    if (-not (Test-Path $historyPath)) {
        New-Item -ItemType Directory -Path $historyPath -Force | Out-Null
    }

    Register-EngineEvent PowerShell.Exiting -Action {
        $historyDir = "$env:USERPROFILE\workspace\history"
        $today      = (Get-Date).ToString('yyyy-MM-dd')
        $mdFile     = Join-Path $historyDir "$today.md"
        $cmds       = Get-History

        if (-not $cmds -or $cmds.Count -eq 0) { return }

        $sb = [System.Text.StringBuilder]::new()

        # If file doesn't exist yet, add a frontmatter header
        if (-not (Test-Path $mdFile)) {
            [void]$sb.AppendLine("# Command History — $today")
            [void]$sb.AppendLine("")
        } else {
            [void]$sb.AppendLine("")  # blank line before new session
        }

        # Session header — time-of-day label + short time range
        $startTime = $cmds[0].StartExecutionTime
        $endTime   = $cmds[-1].EndExecutionTime
        $hour      = $startTime.Hour
        $period    = if ($hour -lt 6) { 'Late Night' }
                     elseif ($hour -lt 12) { 'Morning' }
                     elseif ($hour -lt 17) { 'Afternoon' }
                     elseif ($hour -lt 21) { 'Evening' }
                     else { 'Night' }
        $tStart = $stadhtTime.ToString('h:mm tt').ToLower()
        $tEnd   = $endTime.ToString('h:mm tt').ToLower()

        [void]$sb.AppendLine("## $period  ·  $tStart – $tEnd")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("| | Time | Dur | Command |")
        [void]$sb.AppendLine("|:-:|------|----:|---------|")

        foreach ($c in $cmds) {
            $time    = $c.StartExecutionTime.ToString('h:mmtt').ToLower()
            $cmdText = $c.CommandLine -replace '\|', '\|' -replace '\n', ' '
            # Human-friendly duration
            $totalSec = $c.Duration.TotalSeconds
            $dur = if ($totalSec -lt 1) { '{0:N0}ms' -f ($totalSec * 1000) }
                   elseif ($totalSec -lt 60) { '{0:N1}s' -f $totalSec }
                   else { '{0:N0}m {1:N0}s' -f [math]::Floor($totalSec / 60), ($totalSec % 60) }
            $icon = if ($c.ExecutionStatus -eq 'Completed') { '✓' } else { '✗' }
            [void]$sb.AppendLine("| $icon | $time | $dur | $cmdText |")
        }

        $totalDur = ($endTime - $startTime)
        $sessionLen = if ($totalDur.TotalMinutes -lt 1) { '{0:N0}s' -f $totalDur.TotalSeconds }
                      elseif ($totalDur.TotalHours -lt 1) { '{0:N0}m' -f $totalDur.TotalMinutes }
                      else { '{0:N0}h {1:N0}m' -f [math]::Floor($totalDur.TotalHours), ($totalDur.TotalMinutes % 60) }
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("> $($cmds.Count) commands · $sessionLen")
        [void]$sb.AppendLine("")

        # Append to the daily file
        Add-Content -Path $mdFile -Value $sb.ToString() -Encoding UTF8
    } -SupportEvent
}

Export-ModuleMember -Function StartEnd