#!/usr/bin/env bash

# Include library helper for colorized echo
source ./library/helper_echo.sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "Updating OSX.  If this requires a restart, run the setup.sh script again."
action "Installing all available updates..." 
sudo softwareupdate -ia --verbose
ok

if test ! $(xcode-select -p); then
  action "Installing Xcode Command Line Tools..."
  xcode-select --install
  ok
else 
  ok "already installed"
fi

bot "Checking for homebrew..."
if test ! $(which brew); then
  action "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  action "Installing dropbox..."
  install_cask dropbox
  # Opening Dropbox to login for the first time to sync files needed for config.sh
  open -a "Dropbox" 
  ok
else 
  ok "already installed"
fi

action "Updating homebrew..."
brew update; ok

action "Upgrading brew packages..."
brew upgrade; ok

action "Upgrading brew cask packages..."
brew cask outdated
brew cask upgrade
ok

if test $(which mas); then
  action "Upgrading Mac App Store apps..."
  mas outdated
  mas upgrade
  ok
fi

if test $(which gem); then
  action "Updating ruby gems..."
  gem update
  ok
fi

bot "Cleaning up..."
gem cleanup
brew cleanup