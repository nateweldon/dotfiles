function cd_ca {
    Set-Location $env:LOCAL_WORKSPACE/ca_payx/payx/
}
Set-Alias cd-ca cd_ca

function cd_cadomain {
    Set-Location $env:LOCAL_WORKSPACE/ca_payx/payx/domain/dev
}
Set-Alias cd-cadomain cd_cadomain

function cd_caproxy {
    Set-Location $env:LOCAL_WORKSPACE/ca_payx/payx/enterprise-services/proxywebservices/dev
}
Set-Alias cd-caproxy cd_caproxy
