function ESIG_AddSignaturePage {
    <#
.SYNOPSIS

Adds a signature page to a PDF document

.DESCRIPTION

Uses the esignature-svc LOB service to add a signature page to an existing PDF document. 

#>
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [String]
        $document,

        [Parameter(Position = 1, Mandatory = $true)]
        [String]
        $output,

        [Parameter()]
        [String]
        $baseurl = "http://localhost:8076" ,

        [Parameter()]
        [String]
        $disclaimer = "./disclaimer-multiline.txt",

        [Parameter()]
        [String]
        $metadata = "./mergeDocumentMetadata"
    )

    curl -v `
         -H "Content-Type:multipart/form-data" `
         -F"metadata=@$metadata;type=application/json" `
         -F"disclaimer=@$disclaimer" `
         -F"document=@$document" `
         -o $output `
         "$baseurl/esignature-svc/api/v1/add-signature-page"
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
    Set-PSTitle("Running DocMan Alfresco Svc")
    cd_docmanagement_alfresco_svc
    ./gradlew bootRun
}
Set-Alias start-das start_docman_alfresco_svc