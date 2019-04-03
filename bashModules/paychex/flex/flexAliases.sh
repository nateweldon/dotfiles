########################## HTML5 flex ######################

alias cd-flex='cd $dev_repo/develop'
alias cd-payroll='cd-flex && cd app_payroll'
alias cdp='cd-payroll'
alias phd='cdp && cd html && ant dist'
alias prd='cdp && cd remote && ant dist'
alias phcd='cdp && cd html && ant clean dist'
alias cdp-build='prd && phcd'

alias cdl='cd-flex && cd app_landing'
alias lhd='cdl && cd html && ant dist'

alias cdc='cd-flex && cd app_common'

alias cdd='cd-flex && cd dictionaries'

alias cdf='cd-flex && cd paychex-framework'
alias fhd='cdf && grunt dist'

alias flex-pull-common='cd-flex && cd app_common && git pull'
alias flex-pull-landing='cd-flex && cd app_landing && git pull'
alias flex-pull-company='cd-flex && cd app_company && git pull'
alias flex-pull-payroll='cd-flex && cd app_payroll && git pull'
alias flex-pull-party='cd-flex && cd app_party && git pull'

alias flex-pull-all='flex-pull-common && flex-pull-landing && flex-pull-company && flex-pull-payroll && flex-pull-party'

alias flex-build-common='cdc && ant clean dist'
alias flex-build-landing='cdl && ant clean dist'
alias flex-build-company='cd-flex && cd app_company && ant clean dist'
alias flex-build-payroll='cdp && ant clean dist'
alias flex-build-party='cd-flex && cd app_party && ant dist'

alias flex-build-all='flex-build-common && flex-build-landing && flex-build-company && flex-build-payroll && flex-build-party'

alias flex-update-all='flex-pull-all && flex-build-all'

alias flex-tb-build='cdc && ant dist && cdl && ant dist && cdp && ant dist'
