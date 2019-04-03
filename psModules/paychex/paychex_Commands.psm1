function startwl{
    <#
.SYNOPSIS
Runs the startWebLogic.cmd 
.DESCRIPTION 
startWebLogic.cmd

#> 
    Set-PSTitle("Running WebLogic")
    & C:\Oracle\Middleware_122100\user_projects\domains\flex\bin\startWebLogic.cmd
}

function stopwl{
    <#
.SYNOPSIS
Runs the stopWeblogic.cmd 
.DESCRIPTION 
stopWebLogic.cmd

#> 
    & C:\Oracle\Middleware_122100\user_projects\domains\flex\bin\stopWebLogic.cmd
}
