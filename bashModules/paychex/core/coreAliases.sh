####################################################### CORE ADVANCED ##################################################
alias ca-javaops='export JAVA_OPTS="-Xms1024m -Xmx2048m -XX:-UseGCOverheadLimit"'
alias ca-ant='ca-javaops && export ANT_HOME=$dev_repo/core/ca_payx/payx/tools/lib/ant'
alias cd-ca='ca-ant && cd $dev_repo/core/ca_payx/payx/'
alias cd-cadomain='cd-ca && cd domain/dev'
alias cd-caproxy='cd-ca && cd enterprise-services/proxywebservices/dev'
alias cd-caonline='cd-ca && cd online/dev'

alias ca-superreset='cd-cadomain && ant db.setup && ca-updbandbuild'

alias ca-build='ca-ant && cd-ca && ant veryclean dist.all'
alias ca-build-web='ca-ant && cd-ca && ant webapp.all'
alias ca-updb='cd-cadomain && ant db.update.views && ant db.upgrade && ant db.loadprivate'
alias ca-loadp='cd-cadomain && ant db.loadprivate'
alias ca-devsh='ca-updb && ca-build && ca-desktop-zip'
alias ca-sb='cd-caonline && ant -Dworking.app=sb ws.all'

alias ca-updbandbuild='ca-updb && cd-ca && ant clean dist'
alias ca-pullandbuild='git pull && ca-updbandbuild'
alias ca-check='echo checkcomplete'

alias ca-desktop='cd-ca && cd desktop/dev && ant payroll'
alias ca-desktop-zip='cd-ca && cd desktop/dev && ant zip.client zip.libraries'

alias ca-start='ca-ant && cd-cadomain && ant start.appserver.and.deploy'
alias ca-stop='ca-ant && cd-cadomain && ant appserver.stop'

alias ca-proxy-start='ca-ant && cd-caproxy && ant proxyserver.start.and.deploy'
alias ca-proxy-stop='ca-ant && cd-caproxy && ant proxyserver.stop'

alias wl-ant='export ANT_HOME=$top_dir/Ant/apache-ant-1.10.2-bin/apache-ant-1.10.2'
alias wlDir='cd $oracle_middleware/user_projects/domains/flex/'
alias wl-debug='set debugFlag=true'
alias wl-start='wl-ant && wlDir && wl-debug && ./startWebLogic.cmd'
alias wl-stop='wl-ant && wlDir && cd bin && ./stopWebLogic.cmd'

alias wl-dir11='cd $oracle_middleware11/user_projects/domains/png/'
alias wl-start11='wl-dir11 && wl-debug && ./startWebLogic.cmd'
alias wl-stop11='wl-dir11 && cd bin && ./stopWebLogic.cmd'

alias oc4j-ant='export ANT_HOME=$dev_repo/core/ca_payx/payx/tools/lib/ant'
alias oc4jDir='cd $dev_repo/core/ca_payx/payx/online/dev/webapp/gl'
alias oc4j-start='oc4j-ant && oc4jDir && ant oc4j.start'
alias oc4j-stop='oc4j-ant && oc4jDir && ant oc4j.stop'
