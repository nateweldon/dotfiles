

function StartEnd {
    Write-Host "Logging All Data"
    
    # Ensure history directory exists
    $historyPath = "$env:USERPROFILE\workspace\history"
    if (-not (Test-Path $historyPath)) {
        New-Item -ItemType Directory -Path $historyPath -Force | Out-Null
    }
 
    Register-EngineEvent PowerShell.Exiting -Action {
        Write-Host "This is the End"
        $historyFile = "$env:USERPROFILE\workspace\history\ps_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv"
        Get-History | Export-Csv -Path $historyFile -NoTypeInformation
        Write-Host "History saved to: $historyFile"
        Write-Host "Go Home"
    } -SupportEvent
}

Export-ModuleMember -Function StartEnd