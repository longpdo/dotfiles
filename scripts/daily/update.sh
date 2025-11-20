#!/bin/zsh

# Script updating software packages
# | zsh plugins via Antidote
# | brew and cask packages via Homebrew
# | Ruby gems

# Log Helper
_info() { echo -e "\033[1m[INFO]\033[0m $1" ; }

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
_info "Updating antidote plugins"
antidote update

_info "Updating homebrew and packages"
brew outdated
brew update
brew upgrade

_info "Updating ruby gems"
gem update
