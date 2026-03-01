# Show current Git profile information

function Show-GitProfile {
    <#
    .SYNOPSIS
        Shows the currently active git profile
    
    .DESCRIPTION
        Displays which git configuration is currently active by showing the symbolic link target
        and the current user configuration
    
    .EXAMPLE
        Show-GitProfile
        
        Shows current git profile information including:
        - Which config file is linked
        - User name
        - User email
    #>
    
    Write-Host "`n=== Current Git Profile ===" -ForegroundColor Cyan
    
    # Check if .gitconfig exists and is a symbolic link
    $gitconfigPath = "$env:USERPROFILE\.gitconfig"
    
    if (Test-Path $gitconfigPath) {
        $item = Get-Item $gitconfigPath
        
        if ($item.LinkType -eq "SymbolicLink") {
            Write-Host "`nLinked to: " -NoNewline -ForegroundColor Yellow
            Write-Host $item.Target -ForegroundColor Green
            
            # Determine which profile based on the path
            $target = $item.Target
            if ($target -like "*github*") {
                Write-Host "Profile: " -NoNewline -ForegroundColor Yellow
                Write-Host "GitHub" -ForegroundColor Magenta
            }
            elseif ($target -like "*onestream*" -or $target -like "*OneStream*") {
                Write-Host "Profile: " -NoNewline -ForegroundColor Yellow
                Write-Host "OneStream Software (Azure DevOps)" -ForegroundColor Magenta
            }
            else {
                Write-Host "Profile: " -NoNewline -ForegroundColor Yellow
                Write-Host "Unknown" -ForegroundColor Red
            }
        }
        else {
            Write-Host "`nWarning: .gitconfig is not a symbolic link" -ForegroundColor Red
            Write-Host "Consider using one of the profile switcher commands:" -ForegroundColor Yellow
            Write-Host "  gitgithub or gitonestream`n" -ForegroundColor White
        }
    }
    else {
        Write-Host "`nNo .gitconfig found!" -ForegroundColor Red
    }
    
    # Show user configuration
    Write-Host "`nUser Configuration:" -ForegroundColor Yellow
    $userName = git config --global user.name
    $userEmail = git config --global user.email
    
    if ($userName) {
        Write-Host "  Name:  " -NoNewline
        Write-Host $userName -ForegroundColor Green
    }
    else {
        Write-Host "  Name:  " -NoNewline
        Write-Host "NOT SET" -ForegroundColor Red
    }
    
    if ($userEmail) {
        Write-Host "  Email: " -NoNewline
        Write-Host $userEmail -ForegroundColor Green
    }
    else {
        Write-Host "  Email: " -NoNewline
        Write-Host "NOT SET" -ForegroundColor Red
    }
    
    Write-Host "`n=========================`n" -ForegroundColor Cyan
}

# Create alias
Set-Alias -Name gitprofile -Value Show-GitProfile -Description "Show current git profile"
Set-Alias -Name gitshow -Value Show-GitProfile -Description "Show current git profile"

# Export the function
Export-ModuleMember -Function Show-GitProfile -Alias gitprofile, gitshow
