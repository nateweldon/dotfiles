function bash{
        <#
.SYNOPSIS

Starts a bash schell using mintty

.DESCRIPTION


#>
    Start-Process "C:\cygwin\bin\mintty.exe" -Verb runAs 
}

function dumpHistory{
        <#
.SYNOPSIS

Dumps all PowerShell Saved history 

.DESCRIPTION

Current saved location is "C:\Users\$env:USERNAME\workspace\history\"

#>
    Import-Csv -Path  (Get-ChildItem -Path C:\Users\$env:USERNAME\workspace\history\ -Filter '*.csv').FullName | Select "id", "CommandLine"
}


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

function swap_code {
            <#
.SYNOPSIS

Switches global git config to code.paychex.com version 

.DESCRIPTION

New-Item -Path C:\Users\$env:USERNAME\.gitconfig -ItemType SymbolicLink -Value C:\Users\$env:USERNAME\dotfiles\configs\git\paychex\.gitconfig -Force

#>
    Write-Host "Creating Sym Link for gitConfig -> code.paychex.com"
    New-Item -Path C:\Users\$env:USERNAME\.gitconfig -ItemType SymbolicLink -Value C:\Users\$env:USERNAME\dotfiles\configs\git\paychex\.gitconfig -Force
}

function swap_bucket {
                <#
.SYNOPSIS

Switches global git config to public bitbucket version 

.DESCRIPTION
New-Item -Path C:\Users\$env:USERNAME\.gitconfig -ItemType SymbolicLink -Value C:\Users\$env:USERNAME\dotfiles\configs\git\bitbucket\.gitconfig -Force

#>
     Write-Host "Creating Sym Link for gitconfig -> bitbucket.com"
     New-Item -Path C:\Users\$env:USERNAME\.gitconfig -ItemType SymbolicLink -Value C:\Users\$env:USERNAME\dotfiles\configs\git\bitbucket\.gitconfig -Force
}

function swap_hub {
                <#
.SYNOPSIS

Switches global git config to public gitHub.com version

.DESCRIPTION
New-Item -Path C:\Users\$env:USERNAME\.gitconfig -ItemType SymbolicLink -Value C:\Users\$env:USERNAME\dotfiles\configs\git\github\.gitconfig -Force


#>
     Write-Host "Creating Sym Link for gitconfig -> gitHub.com"
     New-Item -Path C:\Users\$env:USERNAME\.gitconfig -ItemType SymbolicLink -Value C:\Users\$env:USERNAME\dotfiles\configs\git\github\.gitconfig -Force
}

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

