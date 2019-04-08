################################################################################################
function cd_approvals {
<#
.SYNOPSIS
 Move to HR Approvals remote code directory
.DESCRIPTION
Set-Location $env:REPO/remotes/approvals
#>
	Set-Location $env:REPO/remotes/approvals
}
Set-Alias cd-apr cd_approvals
Set-Alias hrapr cd_approvals
################################################################################################
function cd_docmanagement_remote {
<#
.SYNOPSIS
 Move to HR Document Management remote code directory
.DESCRIPTION
Set-Location $env:REPO/remotes/docmanagement-remote
#>
	Set-Location $env:REPO/remotes/docmanagement-remote
}
Set-Alias cd-docrem cd_docmanagement_remote
Set-Alias cd-dr cd_docmanagement_remote
Set-Alias cd-dmr cd_docmanagement_remote
Set-Alias hrdmr cd_docmanagement_remote
################################################################################################
function cd_docmanagement_svc {
<#
.SYNOPSIS
 Move to HR Document Management service code directory
.DESCRIPTION
Set-Location $env:REPO/remotes/docmanagement-svc
#>
	Set-Location $env:REPO/remotes/docmanagement-svc
}
Set-Alias cd-docsvc cd_docmanagement_svc
Set-Alias cd-ds cd_docmanagement_svc
Set-Alias cd-dms cd_docmanagement_svc
Set-Alias hrdms cd_docmanagement_svc
################################################################################################
function cd_docmanagement_alfresco_svc {
	<#
.SYNOPSIS
 Move to HR Document Management alfresco service code directory
.DESCRIPTION
Set-Location $env:REPO/remotes/docmanagement-alfresco-svc
#>
	Set-Location $env:REPO/remotes/docmanagement-alfresco-svc
}
Set-Alias cd-docalfsvc cd_docmanagement_alfresco_svc
Set-Alias cd-das cd_docmanagement_alfresco_svc
Set-Alias cd-dmas cd_docmanagement_alfresco_svc
Set-Alias hrdmas cd_docmanagement_alfresco_svc
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