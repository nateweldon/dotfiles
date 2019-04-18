################################################################################################
function cd_esignature_svc {
<#
.SYNOPSIS
 Move to HR E-Signature service code directory
.DESCRIPTION
Set-Location $env:REPO/remotes/esignature-svc
#>
	Set-Location $env:REPO/remotes/esignature-svc
}
Set-Alias cd-esig cd_esignature_svc
Set-Alias cd-ess cd_esignature_svc
Set-Alias hress cd_esignature_svc