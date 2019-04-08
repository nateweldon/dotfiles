################################################################################################
function cd_weblogic {
<#
.SYNOPSIS
 Move to Weblogic directory for flex
.DESCRIPTION
Set-Location C:/Oracle/Middleware_122100/user_projects/domains/flex
#>
	Set-Location C:/Oracle/Middleware_122100/user_projects/domains/flex
}
Set-Alias cd-weblogic cd_weblogic
Set-Alias cd-wlflex cd_weblogic
Set-Alias wlflex cd_weblogic

################################################################################################
function cd_weblogic_11 {
    <#
.SYNOPSIS
Moves to Weblogic 11 for png
.DESCRIPTION
Set-Location C:/Oracle/Middleware/user_projects/domains/png
#>
    Set-Location C:/Oracle/Middleware/user_projects/domains/png
}
Set-Alias cd-wl-11 cd_weblogic_11
Set-Alias cd-wl11 cd_weblogic_11
Set-Alias wl11flex cd_weblogic_11

################################################################################################
function cd_develop {
    <#
.SYNOPSIS
Moves to top level flex directory
.DESCRIPTION
Set-Location $env:REPO/develop/
#>
    Set-Location $env:REPO/develop/
}
Set-Alias cd-develop cd_develop
Set-Alias cd-flex cd_develop
Set-Alias flex cd_develop

################################################################################################
function cd_remote {
    <#
.SYNOPSIS
Moves to top level remote
.DESCRIPTION
Set-Location $env:REPO/remote/
#>
    Set-Location $env:REPO/remote/
}
Set-Alias cd-remote cd_remote
Set-Alias remote cd_remote

################################################################################################
function cd_app_payroll {
  <#git 
.SYNOPSIS
Moves to flex app_payroll directory
.DESCRIPTION
Set-Location $env:REPO/develop/app_payroll/
#>
    Set-Location $env:REPO/develop/app_payroll/
}
Set-Alias cd-payroll cd_app_payroll
Set-Alias cdp cd_app_payroll
Set-Alias apayroll cd_app_payroll

################################################################################################
function cd_app_landing {
  <#
.SYNOPSIS
Move to flex app_landing directory
.DESCRIPTION
Set-Location $env:REPO/develop/app_landing/
#>
    Set-Location $env:REPO/develop/app_landing/
}
Set-Alias cd-landing cd_app_landing
Set-Alias cdl cd_app_landing
Set-Alias alanding cd_app_landing

################################################################################################
function cd_app_common {
  <#
.SYNOPSIS
Move to flex app_common directory
.DESCRIPTION
Set-Location $env:REPO/develop/app_common/
#>
    Set-Location $env:REPO/develop/app_common/
}
Set-Alias cd-common cd_app_common
Set-Alias cdc cd_app_common
Set-Alias acommon cd_app_common

################################################################################################
function cd_app_docmanagement {
    <#
.SYNOPSIS
Move to flex app_docmanagement directory
.DESCRIPTION
Set-Location $env:REPO/develop/app_docmanagement/
#>
    Set-Location $env:REPO/develop/app_docmanagement/
}
Set-Alias cd-docmanagement cd_app_docmanagement
Set-Alias cd-appdoc cd_app_docmanagement
Set-Alias cd-doc cd_app_docmanagement