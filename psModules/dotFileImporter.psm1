$excluded = @("dotFileImporter.psm1")
$psm1Files = Get-ChildItem -Path "$env:USERPROFILE\workspace\dotfiles" -Recurse *.psm1 -Exclude $excluded

# ── Startup Banner ──────────────────────────────────────────────────────────
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

$dotfilesVersion = & git -C "$env:USERPROFILE\workspace\dotfiles" describe --tags --always 2>$null
if (-not $dotfilesVersion) { $dotfilesVersion = "unknown" }
$username = $env:USERNAME

Write-Host ""
Write-Host "   \\ | //   " -ForegroundColor DarkGreen -NoNewline
Write-Host "Welcome back, " -ForegroundColor DarkGray -NoNewline
Write-Host $username -ForegroundColor Cyan
Write-Host "    \_^_/    " -ForegroundColor DarkGreen -NoNewline
Write-Host "dotfiles " -ForegroundColor DarkGray -NoNewline
Write-Host "v$dotfilesVersion" -ForegroundColor Yellow
Write-Host "   ( o o )  " -ForegroundColor DarkGreen
Write-Host "    \ Y /   " -ForegroundColor DarkGreen
Write-Host "     | |    " -ForegroundColor DarkGreen
Write-Host "    /   \   " -ForegroundColor DarkGreen

# ── Load modules silently, collect results ──────────────────────────────────
$loaded    = @()
$failed    = @()
$aliases   = @()

foreach ($psm1 in $psm1Files) {
    $moduleName = $psm1.BaseName
    $folder     = Split-Path (Split-Path $psm1.FullName -Parent) -Leaf
    $label      = if ($folder -eq 'psModules') { $moduleName } else { "$folder/$moduleName" }

    try {
        $before = (Get-Alias -ErrorAction SilentlyContinue | Measure-Object).Count
        Import-Module -Name $psm1 -ErrorAction Stop -DisableNameChecking
        $after  = (Get-Alias -ErrorAction SilentlyContinue | Measure-Object).Count
        $newAliases = $after - $before
        $loaded += $label
        if ($newAliases -gt 0) {
            # Grab the aliases that were just added by this module
            $moduleAliases = (Get-Module $moduleName -ErrorAction SilentlyContinue |
                Select-Object -ExpandProperty ExportedAliases -ErrorAction SilentlyContinue).Keys
            if ($moduleAliases) { $aliases += $moduleAliases }
        }
    } catch {
        $failed += $label
    }
}

# ── Print results ───────────────────────────────────────────────────────────
$stopwatch.Stop()

# Modules
Write-Host ""
Write-Host "  Modules " -ForegroundColor DarkGray -NoNewline
Write-Host "($($loaded.Count) loaded)" -ForegroundColor Green
foreach ($m in $loaded) {
    Write-Host "    ✓ " -ForegroundColor DarkGreen -NoNewline
    Write-Host $m -ForegroundColor Gray
}
foreach ($m in $failed) {
    Write-Host "    ✗ " -ForegroundColor Red -NoNewline
    Write-Host $m -ForegroundColor DarkRed
}

# Aliases
if ($aliases.Count -gt 0) {
    Write-Host ""
    Write-Host "  Aliases " -ForegroundColor DarkGray -NoNewline
    Write-Host "($($aliases.Count))" -ForegroundColor Cyan
    $aliasLine = "    " + ($aliases -join "  ")
    Write-Host $aliasLine -ForegroundColor DarkCyan
}

# Git profile
$gitProfile = $env:GIT_PROFILE
if ($gitProfile) {
    Write-Host ""
    Write-Host "  Git " -ForegroundColor DarkGray -NoNewline
    Write-Host "$gitProfile" -ForegroundColor Magenta
}

# Timing
Write-Host ""
Write-Host "  Ready in $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor DarkGray
Write-Host ""

# ── Register session history logger ────────────────────────────────────────
StartEnd