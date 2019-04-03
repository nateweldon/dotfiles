###################################################### PNG GENERAL #####################################################
export AUTODEPLOY_DIR=$oracle_middleware/user_projects/domains/flex/autodeploy/
export CURRENT_POPULATOR='InMemoryCommandPopulator'
export POPULATOR_BASE='party.populator=com.paychex.party.root.commands.'
export PNG_PROJECT=''

## quick swap commands
alias populator="export POPULATOR_BASE='$PNG_PROJECT.populator=com.paychex.$PNG_PROJECT.root.commands.'"
alias inmemory='export CURRENT_POPULATOR=InMemoryCommandPopulator'
alias remote='export CURRENT_POPULATOR=RemoteCommandPopulator'

alias cd-png='cd $CURRENT_PNG_ENVIRONMENT'
alias cd-proj='cd-png && cd ssoapps/$PNG_PROJECT'

alias clean='ant clean'
#alias norm='populator && ant dist -D$POPULATOR_BASE$CURRENTPOPULATOR'
alias norm='ant dist'
alias wrap='ant -DswfMode=wrapper dist'
alias purge='ant weblogic-purge'

##################################################### PNG Projects #####################################################
## Project locations
#alias cd-company='export PNG_PROJECT="company" && cd-proj '
#alias cd-party='export PNG_PROJECT="party" && cd-proj'
#alias cd-payroll='export PNG_PROJECT="payroll" && cd-proj'
#alias cd-landing='export PNG_PROJECT="landing" && cd-proj'
#alias cd-common='export PNG_PROJECT="common" && cd-proj'
#alias cd-people='export PNG_PROJECT="people" && cd-proj'

#Build all PNG apps
alias png-all='uifw-clean && common-clean && landing-clean && company-clean && people-clean && party-clean && payroll-clean'

#common
alias common='wl-ant && cd-png && cd ssoapps/common && norm'
alias common-clean='wl-ant && cd-png && cd ssoapps/common && clean && norm'

#common
alias common='wl-ant && cd-common && norm'
alias common-clean='wl-ant && cd-common && clean && norm'

#uifw
alias uifw='wl-ant && cd-png && cd uifw && norm'
alias uifw-clean='wl-ant && cd-png && cd uifw && clean && norm'

#landing
alias cd-landing='wl-ant && cd $dev_repo/develop/app_landing'
alias landing='wl-ant && cd-landing && norm'
alias landing-clean='wl-ant && cd-landing && clean && norm && cd ui && norm'

#people
alias people='wl-ant && cd-people && norm'
alias people-clean='wl-ant && cd-people && clean && norm'
alias people-wrap='wl-ant && cd-people && wrap'
alias people-clean-wrap='wl-ant && cd-people && clean && wrap'

#party
alias party='wl-ant && cd-party && norm'
alias party-clean='wl-ant && cd-party && clean && norm'
alias party-wrap='wl-ant && cd-party && wrap'
alias party-clean-wrap='wl-ant && cd-party && clean && wrap'

#payroll
alias payroll='wl-ant && cd-payroll && norm'
alias payroll-clean='wl-ant && cd-payroll && clean && norm'
alias payroll-wrap='wl-ant && cd-payroll && wrap'
alias payroll-clean-wrap='wl-ant && cd-payroll && clean && wrap'

#company
alias company='wl-ant && cd-company && norm'
alias company-clean='wl-ant && cd-company && clean && norm'
alias company-wrap='wl-ant && cd-company && wrap'
alias company-clean-wrap='wl-ant && cd-company && clean && wrap'
