#!/bin/zsh

# Script updating software packages and backing up current configurations with mackup
# | macOS software
# | zsh plugins via Antibody
# | brew and cask packages via Homebrew
# | App Store Apps via mas
# | Ruby gems

# Include library helper for colorized echo
source ~/dev/dotfiles/scripts/_helpers/colorized-echo.sh

sudo -v
bot "Starting update script..."
action "Installing all available updates"
sudo softwareupdate -ia --verbose

action "Updating antibody plugins"
antibody update

action "Updating homebrew and packages"
brew update
brew upgrade

action "Upgrading brew cask packages"
brew cask outdated
brew cask upgrade

action "Upgrading App Store apps"
mas outdated
mas upgrade

action "Updating ruby gems"
gem update

bot "Cleaning up..."
action "Cleaning up brew packages"
brew bundle dump
brew bundle --force cleanup
brew cleanup -v
rm Brewfile

action "Cleaning up ruby gems"
gem cleanup -v

action "Deleting `.DS_Store` files"
find . -type f -name '*.DS_Store' -ls -delete

action "Backing up application settings with mackup"
mackup backup
