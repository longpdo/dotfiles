#!/usr/bin/env bash

# Include library helper for colorized echo
source ./library/helper_echo.sh
source ./library/helper_install.sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "Updating OSX.  If this requires a restart, run the setup.sh script again."

action "Checking if system is a mac..."
if [[ $(uname) != 'Darwin' ]]; then
  error "You are not on a mac."
  exit
else
  ok
fi

action "Installing all available updates..."
sudo softwareupdate -ia --verbose
ok

action "Checking if xcode is installed..."
if test ! $(xcode-select -p); then
  running "Installing Xcode Command Line Tools..."
  xcode-select --install
  ok
else
  ok "already installed"
fi

action "Checking for homebrew..."
if test ! $(which brew); then
  running "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  running "Installing dropbox..."
  install_cask dropbox
  # Opening Dropbox to login for the first time to sync files needed for config.sh
  open -a "Dropbox"
  ok
else
  ok "already installed"
fi
