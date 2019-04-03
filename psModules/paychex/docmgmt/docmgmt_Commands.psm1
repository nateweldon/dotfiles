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