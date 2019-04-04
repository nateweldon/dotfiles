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