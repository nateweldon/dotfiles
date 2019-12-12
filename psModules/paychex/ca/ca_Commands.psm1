function ca_javaops {
    $env:JAVA_OPTS="-Xms1024m -Xmx2048m -XX:-UseGCOverheadLimit"
}
Set-Alias ca-javaops ca_javaops

function Set-CoreAnt {
    <#
.SYNOPSIS

Sets ANT_HOME Env Variable for CA Core

.DESCRIPTION

Uses C:repo/ca_payx/payx/tools/lib/ant for ant Home
Note %ANT_HOME%/bin is in path

#>
    ca-javaops
    $Env:ANT_HOME = "$env:REPO\ca_payx\payx\tools\lib\ant"
}
Set-Alias ca-ant Set-CoreAnt

function ca_dbsetup {
    cd-cadomain
    ant db.setup
    cd-ca
}
Set-Alias ca-dbsetup ca_dbsetup

function ca_update_db {
    cd-cadomain
    ant db.upgrade
    ant db.loadprivate
    cd-ca
}
Set-Alias ca-updb ca_update_db

function ca_build {
    cd-ca
    ant clean dist
}
Set-Alias ca-build ca_build

function ca_extra_build {
    cd-ca
    ant veryclean dist.all
}
Set-Alias ca-extrabuild ca_extra_build
Set-Alias ca-xbuild ca_extra_build

function ca_update_and_build {
    ca-updb
    ca-build
}
Set-Alias ca-updbandbuild ca_update_and_build
Set-Alias ca-refresh ca_update_and_build

function ca_pull_update_build {
    cd-ca
    git pull
    ca-updbandbuild
}
Set-Alias ca-pullandbuild ca_pull_update_build

function ca_desktop {
    cd-desktop
    ant payroll
}
Set-Alias ca-desktop ca_desktop
Set-Alias ca-app ca_desktop
Set-Alias ca-swing ca_desktop

function ca_start {
    cd-cadomain
    ant start.appserver.and.deploy
}
Set-Alias ca-start ca_start

function ca_stop {
    cd-cadomain
    ant appserver.stop
}
Set-Alias ca-stop ca_stop

function ca_proxy_start {
    cd-caproxy
    ant proxyserver.start.and.deploy
}
Set-Alias ca-proxy-start ca_proxy_start

function ca_proxy_stop {
    cd-caproxy
    ant proxyserver.stop
}
Set-Alias ca-proxy-stop ca_proxy_stop