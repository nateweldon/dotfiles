function cd_ca {
    ca-ant
    Set-Location $env:REPO/core/ca_payx/payx/
}
Set-Alias cd-ca cd_ca

function cd_cadesktop {
    cd-ca
    Set-Location desktop/dev
}
Set-Alias cd-cadesktop cd_cadesktop
Set-Alias cd-desktop cd_cadesktop

function cd_cadomain {
    cd-ca
    Set-Location domain/dev
}
Set-Alias cd-cadomain cd_cadomain

function cd_caproxy {
    cd-ca
    Set-Location enterprise-services/proxywebservices/dev
}
Set-Alias cd-caproxy cd_caproxy
