function ESIG_SVC {
<#
.SYNOPSIS

Adds a signature page to a PDF document

.DESCRIPTION

Uses the esignature-svc LOB service to add a signature page to an existing PDF document. 

#>
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateSet("add-signature-page", "sign-document")]
        [String]
        $endpoint,

        [Parameter(Position = 1, Mandatory = $true)]
        [String]
        $document,

        [Parameter(Position = 2, Mandatory = $true)]
        [String]
        $output,

        [Parameter()]
        [String]
        $baseapi = "esignature-svc/api/v1" ,

        [Parameter()]
        [String]
        $baseurl = "http://localhost:8076" ,

        [Parameter()]
        [String]
        $disclaimer = "./disclaimer-multiline.txt",

        [Parameter()]
        [String]
        $metadata = "./mergeDocumentMetadata",

        [Parameter()]
        [String]
        $signature = "./signatureData"
    )

    $api = "$baseurl/$baseapi/$endpoint"
    "Calling [$api]..."

    if ($endpoint -eq "add-signature-page") {
        curl -v `
            -H "Content-Type:multipart/form-data" `
            -F"metadata=@$metadata;type=application/json" `
            -F"disclaimer=@$disclaimer" `
            -F"document=@$document" `
            -o $output `
            $api
    } elseif ($endpoint -eq "sign-document") {
        curl -v `
            -H "Content-Type:multipart/form-data" `
            -F"metadata=@$metadata;type=application/json" `
            -F"signatureData=@$signature" `
            -F"document=@$document" `
            -o $output `
            $api
    }

}

function start_docman_remote {
    Set-PSTitle("Running DocMan Remote")
    cd_docmanagement_remote
    ./gradlew bootRun
}
Set-Alias start-dr start_docman_remote

function start_docman_remote_n2a {
    Set-PSTitle("Running DocMan Remote-N2A")
    cd_docmanagement_remote
    ./gradlew bootRun -Penv=local-n2a
}
Set-Alias start-dr-n2a start_docman_remote_n2a

function start_docman_svc {
    Set-PSTitle("Running DocMan Svc")
    cd_docmanagement_svc
    ./gradlew bootRun
}
Set-Alias start-ds start_docman_svc

function start_docman_alfresco_svc {
<#
.SYNOPSIS
 Start the Docman Alfresco Svc
.DESCRIPTION
Set-Location $env:REPO/remotes/docmanagement-alfresco-svc/runner/docker-compose
docker-compose up
#>
    Set-PSTitle("Running DocMan Alfresco Svc")
    cd_docmanagement_alfresco_svc
    Set-Location runner/docker-compose
    docker-compose up
}
Set-Alias start-das start_docman_alfresco_svc
Set-Alias run-das start_docman_alfresco_svc

function build_docman_alfresco_svc {
<#
.SYNOPSIS
 Stop/remove existing docker images and build new images for the Docman Alfresco Svc
.DESCRIPTION
Set-Location $env:REPO/remotes/docmanagement-alfresco-svc
docker container <stop/rm> docker-compose_<content/share/oracle>_1
./gradlew clean build dockerBuild
#>
    cd_docmanagement_alfresco_svc

    # Make sure there are no existing Docker containers, that would
    # prohibit the associated Docker images from being removed and updated.
    docker container stop docker-compose_content_1
    docker container rm docker-compose_content_1

    docker container stop docker-compose_share_1
    docker container rm docker-compose_share_1

    docker container stop docker-compose_oracle_1
    docker container rm docker-compose_oracle_1

    ./gradlew clean build dockerBuild
}
Set-Alias build-das build_docman_alfresco_svc
Set-Alias build-all-modules build_docman_alfresco_svc