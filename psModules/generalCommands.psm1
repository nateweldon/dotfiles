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

Current saved location is "$env:USERPROFILE\workspace\history\"

#>
    Import-Csv -Path  (Get-ChildItem -Path $env:USERPROFILE\workspace\history\ -Filter '*.csv').FullName | Select "id", "CommandLine"
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

function SetGitPaychex {
            <#
.SYNOPSIS

Switches global git config to code.paychex.com version 

.DESCRIPTION

New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\dotfiles\configs\git\paychex\.gitconfig -Force

#>
    Write-Host "Creating Sym Link for gitConfig -> code.paychex.com"
    New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\dotfiles\configs\git\paychex\.gitconfig -Force
}

function SetGitBitbucket {
                <#
.SYNOPSIS

Switches global git config to public bitbucket version 

.DESCRIPTION
New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\dotfiles\configs\git\bitbucket\.gitconfig -Force

#>
     Write-Host "Creating Sym Link for gitconfig -> bitbucket.com"
     New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\dotfiles\configs\git\bitbucket\.gitconfig -Force
}

function SetGitGitHub {
                <#
.SYNOPSIS

Switches global git config to public gitHub.com version

.DESCRIPTION
New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\dotfiles\configs\git\github\.gitconfig -Force


#>
     Write-Host "Creating Sym Link for gitconfig -> gitHub.com"
     New-Item -Path $env:USERPROFILE\.gitconfig -ItemType SymbolicLink -Value $env:USERPROFILE\dotfiles\configs\git\github\.gitconfig -Force
}

function cd_dotfiles {
    Set-Location ~/dotfiles
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


