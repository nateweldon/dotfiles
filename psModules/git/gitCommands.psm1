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
Set-Alias -Name gitcm -Value commitWithMessage -description "git commit --verbose --message"

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
Set-Alias -Name gita -Value AddAllFiles

function pushOrigin() {
 <#
.SYNOPSIS
git push 
.DESCRIPTION 
gitp
.NOTES
git push shortcut command
TODO investigate --prune
#>     
    git push 
}
Set-Alias -Name gitp -value pushOrigin

function git_status() {
    git status
}
Set-Alias gits git_status
Set-Alias gs git_status