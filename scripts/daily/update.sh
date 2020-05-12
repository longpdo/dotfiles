#!/bin/bash

# Script updating software packages
# | zsh plugins via Antibody
# | brew and cask packages via Homebrew
# | App Store Apps via mas
# | Ruby gems

# Log Helper
_info() { echo -e "\033[1m[INFO]\033[0m $1" ; }

_info "Updating antibody plugins"
antibody update

_info "Updating homebrew and packages"
brew update
brew upgrade

_info "Upgrading brew cask packages"
brew cask outdated
brew cask upgrade

_info "Upgrading App Store apps"
mas outdated
mas upgrade

_info "Updating ruby gems"
gem update
