

 function StartEnd {
    write-host "Logging All Data"
 
    Register-EngineEvent PowerShell.Exiting -Action {
        write-host "This is the End"
         Get-History| Export-Csv "C:\Users\$env:USERNAME\workspace\history\ps_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).csv"
         write-host "Go Home"
    }
 }