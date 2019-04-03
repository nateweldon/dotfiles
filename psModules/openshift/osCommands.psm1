


function ocBuildEnvUpdate{
<#
.SYNOPSIS
Set the Openshift env variables correctly in the ose-sandbox.json file
.DESCRIPTION 
Set the Openshift env variables correctly in the ose-sandbox.json file. ose-sandbox.json must be crated first 


#> 
    Write-Host "Setting correct directory $PWD"
    Push-Location $MyInvocation.MyCommand.Path
    [Environment]::CurrentDirectory = $PWD

    Pop-Location
    [Environment]::CurrentDirectory = $PWD

     [string]$oseFile = "$PWD/openshift-sandbox/ose-sandbox.json"

    Write-Host "Updating ose-sandbox.json with Webster Deve "
    (Get-Content $oseFile).replace('{{openshift.environment}}', 'dev') | Set-Content $oseFile
    (Get-Content $oseFile).replace('{{openshift.datacenter}}', 'wdc') | Set-Content $oseFile
    (Get-Content $oseFile).replace('{{openshift.subdomain}}', 'wdc.sandbox.paas.paychex.com') | Set-Content $oseFile
    (Get-Content $oseFile).replace('{{openshift.color}}', 'b') | Set-Content $oseFile
    (Get-Content $oseFile).replace('{{openshift.active.color}}', 'b') | Set-Content $oseFile
    (Get-Content $oseFile).replace('{{openshift.stage.color}}', 'g') | Set-Content $oseFile

}

function ocBuild{
    <#
.SYNOPSIS
Creates everything for an openShift standbox deployment
.DESCRIPTION 
Set of commands run to create needed resourses for Webster Openshift Deployments.
Must be run from valid repo directory. Dpends on .gradlew being there.

#> 
    Write-Host "Setting correct directory $PWD"
    Push-Location $MyInvocation.MyCommand.Path
    [Environment]::CurrentDirectory = $PWD

    Pop-Location
    [Environment]::CurrentDirectory = $PWD

    Write-Host "$PWD/gradlew.bat"
    ./gradlew.bat clean build dockerCopyConfigDockerfile dockerCopyConfigs dockerProcessConfigResources dockerCopyAppDockerfile dockerProcessAppResources generateOpenshiftConfig
 
    Write-Host "cd to build directory"
    cd build

    if((Test-Path -Path $PWD/openShift-sandbox ) )
    {
        Write-Host "Cleaning out openshift-sandbox directory "

        Remove-Item -path $PWD/openshift-sandbox
    }

    Write-Host "Creating openshift-sandbox direcory"
    New-Item -ItemType directory -Path $PWD/openshift-sandbox

    Write-Host "Creating ose-sandbox.json"
    Get-Content openshift/*.json | Add-Content $PWD/openshift-sandbox/ose-sandbox.json
    ocBuildEnvUpdate
}