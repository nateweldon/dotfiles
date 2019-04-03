#this is a test
function commitWithMessage() {
<#
.SYNOPSIS
git commit --verbose --message
.DESCRIPTION 
gitcm
.NOTES
Commits to local git repo with verbose and message flag 
#>  
    git commit --verbose --message $args[0]
}

function addAllFiles() {
    <#
.SYNOPSIS
git add .
.DESCRIPTION 
gita
.NOTES
git add from current directory down 
#>  
    git add .
}

function pushOrigin() {
 <#
.SYNOPSIS
git push 
.DESCRIPTION 
gitp
.NOTES
git push shortcut command
TODO invstate --prune
#>     
    git push 
}

Set-Alias -Name gitcm -Value commitWithMessage -description "git commit --verbose --message"
Set-Alias -Name gita -Value AddAllFiles
Set-Alias -Name gitp -value pushOrigin