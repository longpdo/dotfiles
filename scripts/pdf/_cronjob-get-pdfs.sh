#!/bin/bash

# Script which is running every 30 minutes
#
# > Add following line to crontab:
# */30 * * * * /Users/longdo/dev/dotfiles/scripts/pdf/_cronjob-get-pdfs.sh

export PATH='/usr/local/opt/ruby/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/longdo/.local/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/bc/bin:/usr/local/opt/fzf/bin:/Users/longdo/.gem/ruby/2.7.0/bin:/Users/longdo/.local/bin'

_PDF_PATH="$HOME/Documents/broker"
_WATCH_FOLDER_PATH="$HOME/Dropbox/Trade.Republic"
_WATCH_FOLDER_1302_PATH="$HOME/Dropbox/Trade.Republic.1302"


_info "Checking folders for new files"
[ "$(ls "$_WATCH_FOLDER_PATH")" ] && mv "$_WATCH_FOLDER_PATH/*" "$_PDF_PATH"
[ "$(ls "$_WATCH_FOLDER_1302_PATH")" ] && mv "$_WATCH_FOLDER_1302_PATH/*" "$_PDF_PATH"
