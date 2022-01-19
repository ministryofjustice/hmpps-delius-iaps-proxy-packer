#!/usr/bin/env bash
alias .helpers.aliases.list="alias"
alias .helpers.functions.list="declare -F"
alias .network.netstat_active_connections='netstat -pnltu'
alias .processes.all="ps -auxf"
alias .processes.nginx="ps -auxf | grep nginx"


alias .show.linux.distribution='cat /etc/os-release'

alias .aliases.contexts.list='alias | egrep -o "^alias \.([a-z]*)\." | sort -u | egrep -o "\.([a-z]*)\."'
alias .aliases.contexts.list_all='alias | egrep -o "^alias \.([a-z|.]*)=" | sort -u'

function .aliases.grep() {
    alias | grep $1
}
