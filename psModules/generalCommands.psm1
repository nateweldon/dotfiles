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


