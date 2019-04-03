function Set-FlexAnt {
<#
.SYNOPSIS

Sets ANT_HOME Env Variable for Flex

.DESCRIPTION

Uses C:/Ant/apache-ant-1.10.2-bin/apache-ant-1.10.2 for ant Home
Note %ANT_HOME%/bin is in path 

#>
    $Env:ANT_HOME = "C:/apps/apache-ant-1.10.2"
}