# http://serverfault.com/questions/95431
# Function to test for admin settings
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Oh My Posh prompt - powerlevel10k_rainbow theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_rainbow.omp.json" | Invoke-Expression

#posh-git import and settings 
#note: requires a soft link from $env:USERPROFILE\Document\PowerShell\Modules\posh-git to the git repo's src directory (see C:\tools)
Import-Module posh-git

# posh-git 1.x uses nested properties (Oh My Posh handles git status display now)
# $global:GitPromptSettings.BeforeStatus.Text = '['
# $global:GitPromptSettings.AfterStatus.Text  = '] '

#get child items import and ls color settings
Import-Module Get-ChildItemColor

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ll Get-ChildItemColorFormatWide -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
Set-Alias ls-ltr Get-ChildItemColor
Set-Alias vi vim


# bash sell script settings
Import-Module PSReadLine

Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000
# history substring search
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab completion
Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

#Global Imports files 
Import-Module $env:USERPROFILE\workspace\dotfiles\psModules\dotFileImporter.psm1

# Suppose to speed up admin power shell settings
#$env:path = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
#[AppDomain]::CurrentDomain.GetAssemblies() | % {
#  if (! $_.location) {continue}
#  $Name = Split-Path $_.location -leaf
#  Write-Host -ForegroundColor Yellow "NGENing : $Name"
#  ngen install $_.location | % {"`t$_"}
#}


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Set REPO if not set already
if (-not (Test-Path env:REPO)) {
    $env:REPO = "C:\XF"
}
Set-Location $env:REPO


function Reload_Profile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | ForEach-Object {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }    
}
Set-Alias reload-profile Reload_Profile

function PrintPath{
    ($env:Path).Replace(';',"`n")
}



