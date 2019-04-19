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

function build_app_doc {
    cd_app_docmanagement
    Set-Location html
    grunt dist
}
Set-Alias dhg build_app_doc

function build_app_doc_optimized {
    cd_app_docmanagement
    Set-Location html
    grunt dist-optimized
}
Set-Alias dhgo build_app_doc_optimized
