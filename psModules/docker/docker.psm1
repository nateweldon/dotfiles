# Docker PowerShell module
# Add docker-related functions here

# Placeholder - empty module causes import errors
function Get-DockerStatus {
    <#
    .SYNOPSIS
    Check if Docker is running
    #>
    docker info 2>$null | Select-String "Server Version"
}

Export-ModuleMember -Function Get-DockerStatus