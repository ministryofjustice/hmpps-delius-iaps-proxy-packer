#!/usr/bin/env bash
alias .nginx.restart='service nginx restart'
alias .nginx.start='service nginx start'
alias .nginx.stop='service nginx stop'
#user for showing start up errors
alias .nginx.status='systemctl status nginx.service -l'