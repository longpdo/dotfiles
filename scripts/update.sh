#!/bin/bash

# Script updating software packages and backing up current configurations with mackup
# | macOS software
# | zsh plugins via Antibody
# | brew and cask packages via Homebrew
# | App Store Apps via mas
# | Ruby gems

# Log Helper
_info() { echo -e "\033[1m[INFO]\033[0m $1" ; }

sudo -v
_info "Installing all available updates"
sudo softwareupdate -ia --verbose

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

_info "Cleaning up brew packages"
brew bundle dump
brew bundle --force cleanup
brew cleanup -v
rm Brewfile

_info "Cleaning up ruby gems"
gem cleanup -v

_info "Deleting .DS_Store files"
find . -type f -name '*.DS_Store' -ls -delete

_info "Backing up application settings with mackup"
mackup backup
