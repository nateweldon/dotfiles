$excluded = @("dotFileImporter.psm1")
$psm1Files = Get-ChildItem -Path "$env:USERPROFILE\dotfiles" -Recurse *.psm1 -Exclude $excluded

# enumerate the items array
foreach ($psm1 in $psm1Files)
{
    Import-Module -Name $psm1 -Verbose
}

StartEnd