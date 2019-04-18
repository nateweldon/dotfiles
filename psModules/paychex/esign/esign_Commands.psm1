function ESIG_SVC {
<#
.SYNOPSIS

Invokes E-Signature service endpoints for signing PDF documents.

.DESCRIPTION

Uses the esignature-svc LOB service to add a signature page to an existing PDF document. 

#>
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateSet("add-signature-page", "sign-document", "get-status")]
        [String]
        $endpoint,

        [Parameter()]
        [String]
        $baseapi = "esignature-svc/api/v1" ,

        [Parameter()]
        [String]
        $baseurl = "http://localhost:8076" ,

        [Parameter()]
        [String]
        $claimticketnumber = "" ,

        [Parameter()]
        [switch]
        $content,

        [Parameter()]
        [String]
        $disclaimer = "./disclaimer-multiline.txt",

        [Parameter()]
        [String]
        $document,

        [Parameter()]
        [String]
        $metadata = "./mergeDocumentMetadata",

        [Parameter()]
        [String]
        $output,

        [Parameter()]
        [String]
        $signature = "./signatureData",

        [Parameter()]
        [switch]
        $status
    )

    $api = "$baseurl/$baseapi/$endpoint"

    if ($content) {
        curl -v -o $output $api/$claimticketnumber/content
    } elseif ($status) {
        curl $api/$claimticketnumber/status
    } elseif ($endpoint -eq "add-signature-page") {
        "Calling [$api]..."
        curl -v `
            -H "Content-Type:multipart/form-data" `
            -F"metadata=@$metadata;type=application/json" `
            -F"disclaimer=@$disclaimer" `
            -F"document=@$document" `
            -o $output `
            $api
    } elseif ($endpoint -eq "sign-document") {
        if ($claimTicketNumber -ne $null) {
            "Calling [$api] using claimticket..."
            curl -v `
                -H "Content-Type:multipart/form-data" `
                -F"metadata=@$metadata;type=application/json" `
                -F"signatureData=@$signature" `
                -F"claimTicketNumber=$claimticketnumber" `
                -o $output `
                $api
        } else {
            "Calling [$api] using document..."
            curl -v `
                -H "Content-Type:multipart/form-data" `
                -F"metadata=@$metadata;type=application/json" `
                -F"signatureData=@$signature" `
                -F"document=@$document" `
                -o $output `
                $api
        }
    }

}
