function cd_cntlm {
    <#
.SYNOPSIS

Moves to the cntlm directory

.DESCRIPTION

Uses Set-Location "C:\Program Files (x86)\Cntlm"

#>
    Set-Location "C:\Program Files (x86)\Cntlm"
}
Set-Alias cd-cntlm cd_cntlm

function cd_apache {
    <#
.SYNOPSIS

Moves to the cntlm directory

.DESCRIPTION

Uses Set-Location "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\conf\extra"

#>
    Set-Location "C:\Program Files (x86)\Apache Software Foundation\Apache2.2\conf\extra"
}
Set-Alias cd-apache cd_apache

function cd_repo {
    Set-Location $env:REPO
}
Set-Alias cd-repo cd_repo

function cd_cc {
    Set-Location C:/copyclient
}
Set-Alias cd-cc cd_cc


