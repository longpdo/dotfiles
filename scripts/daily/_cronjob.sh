#!/bin/bash

# Script which is running daily with crontab
#
# > Add following line to crontab:
# 30 23 * * * /Users/longdo/dev/dotfiles/scripts/daily/_cronjob.sh >/tmp/stdout.log 2>/tmp/stderr.log

export PATH='/usr/local/opt/ruby/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/longdo/.local/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/bc/bin:/usr/local/opt/fzf/bin:/Users/longdo/.gem/ruby/2.7.0/bin:/Users/longdo/.local/bin'

# Log Helper
_info() { echo -e "\033[33m[INFO]\033[0m $1" ; }

date

_info "Running backup.sh"
# Answer every mackup prompt for overwriting with 'yes' when running backup.sh
yes | /Users/longdo/dev/dotfiles/scripts/daily/backup.sh

_info "Running update.sh"
/Users/longdo/dev/dotfiles/scripts/daily/update.sh

_info "Running cleanup.sh"
/Users/longdo/dev/dotfiles/scripts/daily/cleanup.sh

_info "Running rebuild-github-pages.sh"
/Users/longdo/dev/dotfiles/scripts/daily/rebuild-github-pages.sh
