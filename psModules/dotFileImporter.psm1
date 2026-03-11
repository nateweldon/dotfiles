$excluded = @("dotFileImporter.psm1")
$psm1Files = Get-ChildItem -Path "$env:USERPROFILE\workspace\dotfiles" -Recurse *.psm1 -Exclude $excluded

# ── Version & User ───────────────────────────────────────────────────────────
$dotfilesVersion = & git -C "$env:USERPROFILE\workspace\dotfiles" describe --tags --always 2>$null
if (-not $dotfilesVersion) { $dotfilesVersion = "unknown" }
$username = $env:USERNAME

# ── Load modules silently, collect results ──────────────────────────────────
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$loaded    = [System.Collections.Generic.List[hashtable]]::new()
$failed    = @()
$aliases   = @()

foreach ($psm1 in $psm1Files) {
    $moduleName = $psm1.BaseName
    $folder     = Split-Path (Split-Path $psm1.FullName -Parent) -Leaf
    $label      = if ($folder -eq 'psModules') { $moduleName } else { "$folder/$moduleName" }

    try {
        $before = (Get-Alias -ErrorAction SilentlyContinue | Measure-Object).Count
        Import-Module -Name $psm1 -ErrorAction Stop -DisableNameChecking -WarningAction SilentlyContinue
        $after  = (Get-Alias -ErrorAction SilentlyContinue | Measure-Object).Count
        $newAliases = $after - $before
        $moduleAliases = @()
        if ($newAliases -gt 0) {
            $moduleAliases = @((Get-Module $moduleName -ErrorAction SilentlyContinue |
                Select-Object -ExpandProperty ExportedAliases -ErrorAction SilentlyContinue).Keys)
            if ($moduleAliases) { $aliases += $moduleAliases }
        }
        $loaded.Add(@{ label = $label; aliasCount = $moduleAliases.Count })
    } catch {
        $failed += $label
    }
}

$stopwatch.Stop()

# ── Build Banner ─────────────────────────────────────────────────────────────
$gitProfile   = $env:GIT_PROFILE
$gitIcon      = $env:GIT_PROFILE_ICON
$totalAliases = $aliases.Count

$mooseLines = @(
    '   ___            ___',
    '  /   \          /   \',
    '  \_   \        /  __/',
    '   _\   \      /  /__',
    '   \___  \____/   __/',
    '       \_       _/',
    '         | @ @  \_',
    '         |',
    '       _/     /\',
    '      /o)  (o/\ \_',
    '      \_____/ /  ',
    '        \____/   '
)

# Each row on the right is an array of @{t=text; c=color} segments
$R = @()
$R += ,@( @{t="  Welcome back, "; c="DarkGray"}, @{t=$username; c="Cyan"} )
$R += ,@( @{t="  dotfiles "; c="DarkGray"}, @{t=$dotfilesVersion; c="Yellow"} )
$R += ,@( @{t=""; c="White"} )
$R += ,@( @{t="  Modules "; c="DarkGray"}, @{t="($($loaded.Count))"; c="Green"}, @{t="  ·  $totalAliases aliases"; c="DarkGray"} )
foreach ($m in $loaded) {
    $aliasTag = if ($m.aliasCount -gt 0) { " ($($m.aliasCount))" } else { "" }
    $R += ,@( @{t="    "; c="White"}, @{t="✓ "; c="DarkGreen"}, @{t=$m.label; c="Gray"}, @{t=$aliasTag; c="DarkCyan"} )
}
foreach ($m in $failed) {
    $R += ,@( @{t="    "; c="White"}, @{t="✗ "; c="Red"}, @{t=$m; c="DarkRed"}, @{t=""; c="White"} )
}
if ($gitProfile) {
    $R += ,@( @{t=""; c="White"} )
    $R += ,@( @{t="  Git: "; c="DarkGray"}, @{t="$gitIcon $gitProfile"; c="Magenta"} )
}
$R += ,@( @{t="  Load Time: "; c="DarkGray"}, @{t="$($stopwatch.ElapsedMilliseconds)ms"; c="Green"} )

$mooseWidth = ($mooseLines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
$rightWidth = ($R | ForEach-Object {
    ($_ | ForEach-Object { $_.t.Length } | Measure-Object -Sum).Sum
} | Measure-Object -Maximum).Maximum

$innerWidth = 1 + $mooseWidth + 2 + $rightWidth + 1
$maxRows    = [Math]::Max($mooseLines.Count, $R.Count)
$g          = "DarkGreen"

Write-Host ""
Write-Host ("  ┌" + ("─" * $innerWidth) + "┐") -ForegroundColor $g
for ($i = 0; $i -lt $maxRows; $i++) {
    Write-Host "  │ " -ForegroundColor $g -NoNewline

    $ml = if ($i -lt $mooseLines.Count) { $mooseLines[$i] } else { "" }
    Write-Host $ml.PadRight($mooseWidth) -ForegroundColor Green -NoNewline
    Write-Host "  " -NoNewline

    $rowLen = 0
    if ($i -lt $R.Count) {
        foreach ($seg in $R[$i]) {
            Write-Host $seg.t -ForegroundColor $seg.c -NoNewline
            $rowLen += $seg.t.Length
        }
    }
    Write-Host (" " * ($rightWidth - $rowLen + 1)) -NoNewline
    Write-Host "│" -ForegroundColor $g
}
Write-Host ("  └" + ("─" * $innerWidth) + "┘") -ForegroundColor $g
Write-Host ""

# ── Register session history logger ────────────────────────────────────────
StartEnd