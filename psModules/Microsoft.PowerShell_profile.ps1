# http://serverfault.com/questions/95431
# Function to test for admin settings
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# main shell prompt settings
function prompt {
    # https://github.com/dahlbyk/posh-git/wiki/Customizing-Your-PowerShell-Prompt
    $origLastExitCode = $LastExitCode
    Write-VcsStatus

    if (Test-Administrator) {  # if elevated
        Write-Host "admin " -NoNewline -ForegroundColor White
    }

    Write-Host "$env:USERNAME@" -NoNewline -ForegroundColor DarkYellow
    Write-Host "$env:COMPUTERNAME" -NoNewline -ForegroundColor Magenta
    Write-Host " : " -NoNewline -ForegroundColor DarkGray

    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if ($curPath.ToLower().StartsWith($Home.ToLower()))
    {
        $curPath = "~" + $curPath.SubString($Home.Length)
    }

    Write-Host $curPath -NoNewline -ForegroundColor Green
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    $LastExitCode = $origLastExitCode
    "`n$('>' * ($nestedPromptLevel + 1)) "
}

#posh-get import and settings 
#note: requires a soft link from $env:USERPROFILE\Document\PowerShell\Modules\posh-git to the git repo's src directory (see C:\tools)
Import-Module posh-git

$global:GitPromptSettings.BeforeText = '['
$global:GitPromptSettings.AfterText  = '] '

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
Import-Module $env:USERPROFILE\dotfiles\psModules\dotFileImporter.psm1

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

# NOT NEEDED IN LATER VERSION OF WINDOWS ??
$env:path += ";" + (Get-Item "Env:ProgramFiles").Value + "\Git\bin"
$env:path += ";" + (Get-Item "Env:ProgramFiles").Value + "\Git\usr\bin"

# SetPath to start in the users workspace
$env:WORKSPACE = "$env:USERPROFILE\workspace"
Set-Location $env:WORKSPACE


function Reload-Profile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | % {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }    
}

function PrintPath{
    ($env:Path).Replace(';',"`n")
}



