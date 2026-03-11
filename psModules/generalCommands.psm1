function dumpHistory {
    <#
.SYNOPSIS
    Shows command history from daily Markdown log files.

.DESCRIPTION
    Reads the daily Markdown history files in ~/workspace/history/.
    With no arguments, shows today's history.
    Use -Date to pick a specific day, or -Days to show the last N days.
    Use -Search to filter commands by keyword.

.PARAMETER Date
    A specific date string (e.g. "2026-03-09"). Defaults to today.

.PARAMETER Days
    Show history for the last N days (e.g. -Days 7).

.PARAMETER Search
    Filter commands containing this text.

.PARAMETER List
    List all available history dates.

.EXAMPLE
    dumpHistory                    # today's history
    dumpHistory -Days 7            # last 7 days
    dumpHistory -Date 2026-03-01   # specific date
    dumpHistory -Search "git"      # search all history for "git"
    dumpHistory -List              # show available dates
    dh -Days 3                     # shorthand
#>
    [CmdletBinding(DefaultParameterSetName = 'Today')]
    param(
        [Parameter(ParameterSetName = 'ByDate')]
        [string]$Date,

        [Parameter(ParameterSetName = 'ByDays')]
        [int]$Days,

        [Parameter()]
        [string]$Search,

        [Parameter(ParameterSetName = 'ListDates')]
        [switch]$List
    )

    $historyDir = "$env:USERPROFILE\workspace\history"
    if (-not (Test-Path $historyDir)) {
        Write-Warning "No history directory found at: $historyDir"
        return
    }

    # -List: show available history files
    if ($List) {
        $files = Get-ChildItem "$historyDir\*.md" | Sort-Object Name -Descending
        if (-not $files) {
            Write-Host "No history files found." -ForegroundColor Yellow
            return
        }
        Write-Host ""
        Write-Host "  Command History" -ForegroundColor Cyan
        Write-Host "  ───────────────" -ForegroundColor DarkGray
        foreach ($f in $files) {
            $size = '{0:N1} KB' -f ($f.Length / 1KB)
            Write-Host "    $($f.BaseName)" -ForegroundColor White -NoNewline
            Write-Host "  ($size)" -ForegroundColor DarkGray
        }
        Write-Host ""
        return
    }

    # Determine which files to read
    $mdFiles = @()
    if ($Date) {
        $mdFiles = @(Join-Path $historyDir "$Date.md")
    } elseif ($Days) {
        for ($i = 0; $i -lt $Days; $i++) {
            $d = (Get-Date).AddDays(-$i).ToString('yyyy-MM-dd')
            $mdFiles += Join-Path $historyDir "$d.md"
        }
    } else {
        $mdFiles = @(Join-Path $historyDir "$(Get-Date -Format 'yyyy-MM-dd').md")
    }

    $anyOutput = $false
    foreach ($mdFile in $mdFiles) {
        if (-not (Test-Path $mdFile)) { continue }
        $lines = Get-Content $mdFile
        $dateName = [System.IO.Path]::GetFileNameWithoutExtension($mdFile)

        if ($Search) {
            $matched = $lines | Where-Object { $_ -like "*$Search*" -and $_ -match '^\|' -and $_ -notmatch '^\|\s*[-:#]' }
            if ($matched) {
                Write-Host ""
                Write-Host "  ── $dateName ──" -ForegroundColor Cyan
                foreach ($line in $matched) {
                    Show-HistoryRow $line $Search
                }
                $anyOutput = $true
            }
        } else {
            $inSession = $false
            foreach ($line in $lines) {
                if ($line -match '^## (.+)') {
                    Write-Host ""
                    if (-not $inSession) {
                        Write-Host "  $dateName" -ForegroundColor DarkGray
                    }
                    Write-Host "  $($Matches[1])" -ForegroundColor Cyan
                    Write-Host "  ─────────────────────────────────────" -ForegroundColor DarkGray
                    $inSession = $true
                } elseif ($line -match '^\|' -and $line -notmatch '^\|\s*[-:#]' -and $line -notmatch '^\|\s*\|?\s*Time\s*\|') {
                    Show-HistoryRow $line
                } elseif ($line -match '^>\s*(.+)') {
                    Write-Host "  $($Matches[1])" -ForegroundColor DarkGray
                }
            }
            if ($inSession) { $anyOutput = $true }
        }
    }

    if (-not $anyOutput) {
        $target = if ($Date) { $Date } elseif ($Days) { "last $Days day(s)" } else { "today" }
        Write-Host "No history found for $target." -ForegroundColor Yellow
        if ($Search) { Write-Host "  Search: '$Search'" -ForegroundColor Yellow }
    }
    Write-Host ""
}

function Show-HistoryRow {
    param(
        [string]$Line,
        [string]$Highlight
    )
    # Parse table row: | icon | Time | Dur | Command |
    $cells = $Line -split '\|' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
    if ($cells.Count -lt 4) { return }

    $icon = $cells[0]
    $time = $cells[1] -replace '``', ''
    $dur  = $cells[2]
    $cmd  = $cells[3] -replace '``', ''

    $iconColor = if ($icon -eq '✗') { 'Red' } else { 'DarkGreen' }
    $iconChar  = if ($icon -eq '✗') { '✗' } else { '✓' }

    Write-Host "  " -NoNewline
    Write-Host $iconChar -ForegroundColor $iconColor -NoNewline
    Write-Host "  " -NoNewline
    Write-Host $time.PadRight(7) -ForegroundColor DarkYellow -NoNewline
    Write-Host $dur.PadLeft(6) -ForegroundColor DarkGray -NoNewline
    Write-Host "  " -NoNewline

    if ($Highlight) {
        $parts = $cmd -split "(?i)($([regex]::Escape($Highlight)))"
        foreach ($p in $parts) {
            if ($p -match "(?i)^$([regex]::Escape($Highlight))$") {
                Write-Host $p -ForegroundColor Yellow -NoNewline
            } else {
                Write-Host $p -ForegroundColor White -NoNewline
            }
        }
        Write-Host ""
    } else {
        Write-Host $cmd -ForegroundColor White
    }
}

Set-Alias -Name dh -Value dumpHistory -Description "Show daily command history"

function dothelp {
    <#
.SYNOPSIS
    Lists all custom dotfile commands or shows detailed help for one.

.DESCRIPTION
    With no arguments, displays every function and alias loaded from
    ~/workspace/dotfiles. Pass a command name to see its full help
    (synopsis, parameters, examples).

.PARAMETER Command
    Name of a specific dotfile function or alias to show help for.

.EXAMPLE
    dothelp                # list all commands
    dothelp dumpHistory    # full help for dumpHistory
    dothelp ica            # works with aliases too
    dh?                    # shorthand for the list
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Command
    )

    $dotfileRoot = "$env:USERPROFILE\workspace\dotfiles"
    $dotModules  = Get-Module | Where-Object { $_.Path -like "$dotfileRoot*" }

    if (-not $dotModules) {
        Write-Warning "No dotfile modules loaded."
        return
    }

    # If a specific command was requested, resolve alias then show help
    if ($Command) {
        # Resolve alias → function name
        $resolved = $Command
        $aliasObj = Get-Alias -Name $Command -ErrorAction SilentlyContinue
        if ($aliasObj -and $aliasObj.ResolvedCommand) {
            $resolved = $aliasObj.ResolvedCommand.Name
        }

        # Verify it belongs to a dotfile module
        $found = $false
        foreach ($mod in $dotModules) {
            if ($mod.ExportedFunctions.ContainsKey($resolved) -or
                $mod.ExportedAliases.ContainsKey($Command)) {
                $found = $true
                break
            }
        }
        if (-not $found) {
            Write-Host "  '$Command' is not a dotfile command." -ForegroundColor Yellow
            Write-Host "  Run " -ForegroundColor DarkGray -NoNewline
            Write-Host "dothelp" -ForegroundColor Cyan -NoNewline
            Write-Host " to see all available commands." -ForegroundColor DarkGray
            return
        }

        # Get help object
        $h = Get-Help $resolved -ErrorAction SilentlyContinue

        Write-Host ""
        Write-Host "  $resolved" -ForegroundColor Cyan
        # Show aliases for this function
        $fnAliases = Get-Alias | Where-Object { $_.ResolvedCommand.Name -eq $resolved } |
            Select-Object -ExpandProperty Name
        if ($fnAliases) {
            Write-Host "  alias: " -ForegroundColor DarkGray -NoNewline
            Write-Host ($fnAliases -join ', ') -ForegroundColor DarkYellow
        }
        Write-Host "  ───────────────────────────────────────" -ForegroundColor DarkGray

        # Synopsis
        if ($h.Synopsis -and $h.Synopsis.Trim()) {
            Write-Host "  $($h.Synopsis.Trim())" -ForegroundColor White
            Write-Host ""
        }

        # Parameters
        $params = $h.parameters.parameter | Where-Object { $_ }
        if ($params) {
            Write-Host "  Parameters" -ForegroundColor DarkGray
            foreach ($p in $params) {
                $pName = $p.Name
                $pType = if ($p.type.name) { "[$($p.type.name)]" } else { '' }
                $pReq  = if ($p.required -eq 'true') { ' *' } else { '' }
                Write-Host "    -$pName" -ForegroundColor Green -NoNewline
                Write-Host " $pType" -ForegroundColor DarkGray -NoNewline
                Write-Host $pReq -ForegroundColor Red
                if ($p.description -and $p.description.Text) {
                    Write-Host "      $($p.description.Text.Trim())" -ForegroundColor Gray
                }
            }
            Write-Host ""
        }

        # Examples
        $examples = $h.examples.example | Where-Object { $_ }
        if ($examples) {
            Write-Host "  Examples" -ForegroundColor DarkGray
            foreach ($ex in $examples) {
                $code = ($ex.code ?? $ex.title ?? '').Trim()
                if ($code) {
                    Write-Host "    $code" -ForegroundColor DarkCyan
                }
                $remarks = ($ex.remarks | ForEach-Object { $_.Text } | Where-Object { $_ }) -join ' '
                if ($remarks.Trim()) {
                    Write-Host "    $($remarks.Trim())" -ForegroundColor DarkGray
                }
            }
            Write-Host ""
        }
        return
    }

    # ── No argument: list all commands ──────────────────────────────────────
    Write-Host ""
    Write-Host "  Dotfile Commands" -ForegroundColor Cyan
    Write-Host "  ════════════════════════════════════════" -ForegroundColor DarkGray

    foreach ($mod in $dotModules | Sort-Object Name) {
        $fns = $mod.ExportedFunctions.Keys | Sort-Object
        if (-not $fns) { continue }

        Write-Host ""
        Write-Host "  $($mod.Name)" -ForegroundColor DarkYellow

        foreach ($fn in $fns) {
            $h = Get-Help $fn -ErrorAction SilentlyContinue
            $synopsis = ''
            if ($h.Synopsis -and $h.Synopsis.Trim() -and $h.Synopsis.Trim() -ne $fn) {
                $synopsis = $h.Synopsis.Trim()
                if ($synopsis.Length -gt 55) { $synopsis = $synopsis.Substring(0, 52) + '...' }
            }

            # Find aliases for this function
            $fnAliases = Get-Alias | Where-Object { $_.ResolvedCommand.Name -eq $fn } |
                Select-Object -ExpandProperty Name

            $aliasStr = if ($fnAliases) { ($fnAliases -join ', ') } else { '' }

            Write-Host "    $($fn.PadRight(25))" -ForegroundColor White -NoNewline
            if ($aliasStr) {
                Write-Host $aliasStr.PadRight(14) -ForegroundColor DarkCyan -NoNewline
            } else {
                Write-Host ''.PadRight(14) -NoNewline
            }
            Write-Host $synopsis -ForegroundColor DarkGray
        }
    }
    Write-Host ""
    Write-Host "  Run " -ForegroundColor DarkGray -NoNewline
    Write-Host "dothelp <command>" -ForegroundColor Cyan -NoNewline
    Write-Host " for details" -ForegroundColor DarkGray
    Write-Host ""
}
Set-Alias -Name 'dh?' -Value dothelp -Description "List dotfile commands"


#creates a SymbolicLink using New-Item
#TODO this does not work yet 
function mklnk {
            <#
.SYNOPSIS

.DESCRIPTION

#>
    param([string]$link, [string]$target)
    Write-Host "Creating Sym Link $link -> $target"
    New-Item -Path $link -ItemType SymbolicLink -Value $target -Force
}

function SetGitGitHub {
                <#
.SYNOPSIS

Switches global git config to public gitHub.com version

.DESCRIPTION
New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\dotfiles\configs\git\github\.gitconfig -Force


#>
     Write-Host "Creating Sym Link for gitconfig -> gitHub.com" -ForegroundColor Cyan
     New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\workspace\dotfiles\configs\git\github\.gitconfig -Force | Out-Null
     
     # Update environment variable for Oh My Posh
     $env:GIT_PROFILE = "GitHub"
     $env:GIT_PROFILE_ICON = "󰊤"
     
     # Verify git config
     $userName = git config --global user.name
     $userEmail = git config --global user.email
     
     Write-Host "✓ Switched to GitHub profile" -ForegroundColor Green
     Write-Host "  User: $userName <$userEmail>" -ForegroundColor Gray
     Write-Host "  Prompt will update on next command" -ForegroundColor Yellow
}

function SetGitOneStream {
                <#
.SYNOPSIS

Switches global git config to OneStream Software Azure DevOps version

.DESCRIPTION
New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\dotfiles\configs\git\oneStreamSoftware\.gitconfig -Force


#>
     Write-Host "Creating Sym Link for gitconfig -> OneStream Software (Azure DevOps)" -ForegroundColor Cyan
     New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\workspace\dotfiles\configs\git\oneStreamSoftware\.gitconfig -Force | Out-Null
     
     # Update environment variable for Oh My Posh
     $env:GIT_PROFILE = "OneStream"
     $global:env:GIT_PROFILE_ICON = [char]0x2298  # ⊘ circled slash
     
     # Verify git config
     $userName = git config --global user.name
     $userEmail = git config --global user.email
     
     Write-Host "✓ Switched to OneStream profile" -ForegroundColor Green
     Write-Host "  User: $userName <$userEmail>" -ForegroundColor Gray
     Write-Host "  Prompt will update on next command" -ForegroundColor Yellow
}

# Create convenient aliases for quick switching
Set-Alias -Name gitgithub -Value SetGitGitHub -Description "Switch to GitHub git profile"
Set-Alias -Name gitonestream -Value SetGitOneStream -Description "Switch to OneStream Software/Azure DevOps git profile"
Set-Alias -Name gitazure -Value SetGitOneStream -Description "Switch to Azure DevOps git profile (OneStream)"
Set-Alias -Name gitwork -Value SetGitOneStream -Description "Switch to work git profile (OneStream)"

function cd_dotfiles {
    Set-Location $env:USERPROFILE\workspace\dotfiles
}
Set-Alias cd-dot cd_dotfiles

function Set-PSTitle {
              <#
.SYNOPSIS

Helper Function to change the PS Terminal Title

.DESCRIPTION
Helper Function to update the PS Terminal Title
General is when you have a long running task like Weblocic or Spring boot you could 
update the title to indicate what the window is doing
#>
    param ( [string] $newtitle)
    $host.ui.RawUI.WindowTitle = $newtitle + " - " + $host.ui.RawUI.WindowTitle;
    }


Set-Alias -Name runH -Value Invoke-History

function Write-Pretty {
      <#
.SYNOPSIS

Added more information around print statments

.DESCRIPTION
Write-Pretty "Test" Info
Write-Pretty "Test" Error
Write-Pretty "Test" Warning
#>
    [cmdletbinding()]
    param(
    [Parameter(
                Mandatory         = $True,
                ValueFromPipeline = $True
               )]
    [Alias('Text')]
    $prettyText,
    [Parameter(Mandatory=$false)]
    [Alias('Type')]
    $textType
    )

    Begin {
    
        Write-Host `n 

    }

    Process {

        ForEach ($textItem in $prettyText) {

            Switch ($textType) {

            
                {$_ -eq 'Error'} {

                    Write-Host -NoNewline "[" -ForegroundColor White 
                    Write-Host -NoNewline "Error" -ForegroundColor Red -BackgroundColor DarkBlue
                    Write-Host -NoNewline "]" -ForegroundColor White 
                    Write-Host " $textItem" -ForegroundColor Red 

                }


                {$_ -eq 'Warning'} {

                    Write-Host -NoNewline "[" -ForegroundColor White
                    Write-Host -NoNewline "Warning" -ForegroundColor Yellow -BackgroundColor Blue
                    Write-Host -NoNewline "]" -ForegroundColor White
                    Write-Host " $textItem" -ForegroundColor Yellow


                }

                {$_ -eq 'Info' -or $_ -eq $null} {

                    Write-Host -NoNewline "[" -ForegroundColor White
                    Write-Host -NoNewline "Info" -ForegroundColor Green -BackgroundColor Black
                    Write-Host -NoNewline "]" -ForegroundColor White
                    Write-Host " $textItem" -ForegroundColor White

                }

                Default { 
        
                    Write-Host $textItem
        
                }

            }

        }

    }

    End {
    
        Write-Host `n

    }

}


