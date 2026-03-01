# Git Profile Detection and Environment Variable Setter

function Update-GitProfileEnv {
    <#
    .SYNOPSIS
        Detects the active git profile and sets environment variable for Oh My Posh
    
    .DESCRIPTION
        Checks which .gitconfig is linked and sets $env:GIT_PROFILE accordingly
        This is used by Oh My Posh to display the active git profile in the prompt
    #>
    
    $gitconfigPath = "$env:USERPROFILE\.gitconfig"
    
    if (Test-Path $gitconfigPath) {
        $item = Get-Item $gitconfigPath
        
        if ($item.LinkType -eq "SymbolicLink") {
            $target = $item.Target
            
            if ($target -like "*github*") {
                $env:GIT_PROFILE = "GitHub"
                $env:GIT_PROFILE_ICON = "󰊤"  # GitHub icon (nerd font)
            }
            elseif ($target -like "*onestream*" -or $target -like "*OneStream*") {
                $env:GIT_PROFILE = "OneStream"
                $env:GIT_PROFILE_ICON = "󰿗"  # Azure DevOps icon (nerd font)
            }
            else {
                $env:GIT_PROFILE = "Unknown"
                $env:GIT_PROFILE_ICON = ""
            }
        }
        else {
            $env:GIT_PROFILE = "Not Linked"
            $env:GIT_PROFILE_ICON = "⚠"
        }
    }
    else {
        $env:GIT_PROFILE = "None"
        $env:GIT_PROFILE_ICON = "✗"
    }
}

# Export the function
Export-ModuleMember -Function Update-GitProfileEnv
