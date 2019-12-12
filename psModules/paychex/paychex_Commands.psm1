function wl_ant {
    $env:ANT_HOME="C:/Ant/apache-ant-1.10.2"
}
Set-Alias wl-ant wl_ant

function startwl{
    <#
.SYNOPSIS
Runs the startWebLogic.cmd
.DESCRIPTION
startWebLogic.cmd

#>
    Set-PSTitle("Running WebLogic")
    wl-ant
    C:\Oracle\Middleware_122100\user_projects\domains\flex\bin\startWebLogic.cmd
}

function stopwl{
    <#
.SYNOPSIS
Runs the stopWeblogic.cmd
.DESCRIPTION
stopWebLogic.cmd

#>
    wl-ant
    C:\Oracle\Middleware_122100\user_projects\domains\flex\bin\stopWebLogic.cmd
}

Set-Alias wl-start startwl
Set-Alias wl-stop stopwl