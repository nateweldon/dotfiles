
[string]$dotFiles = "$env:USERPROFILE\dotfiles"
Import-Module -Name $dotFiles\psModules\generalCommands.psm1
Import-Module -Name $dotFiles\psModules\git\gitCommands.psm1
Import-Module -Name $dotFiles\psModules\paychex\paychex_dirMoves.psm1
Import-Module -Name $dotFiles\psModules\paychex\core\core_Commands.psm1
Import-Module -Name $dotFiles\psModules\paychex\core\core_dirMoves.psm1
Import-Module -Name $dotFiles\psModules\paychex\docmgmt\docmgmt_Commands.psm1
Import-Module -Name $dotFiles\psModules\paychex\docmgmt\docmgmt_dirMoves.psm1
Import-Module -Name $dotFiles\psModules\paychex\flex\flex_Commands.psm1
Import-Module -Name $dotFiles\psModules\paychex\flex\flex_dirMoves.psm1
Import-Module -Name $dotFiles\psModules\datalogger\datalogger.psm1
Import-Module -Name $dotFiles\psModules\paychex\paychex_Commands.psm1
Import-Module -Name $dotFiles\psModules\openshift\osCommands.psm1

StartEnd