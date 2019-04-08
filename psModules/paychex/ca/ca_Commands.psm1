function Set-CoreAnt {
    <#
.SYNOPSIS

Sets ANT_HOME Env Variable for CA Core

.DESCRIPTION

Uses C:repo/ca_payx/payx/tools/lib/ant for ant Home
Note %ANT_HOME%/bin is in path 

#>
    $Env:ANT_HOME = "$env:LOCAL_WORKSPACE\ca_payx\payx\tools\lib\ant"
}