#!/bin/bash

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_ok()      { echo -e "\033[32m[OK]\033[0m $1" ; }
_error()   { echo -e "\033[31m[ERROR]\033[0m $1" ; }

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

_info "Updating OSX.  If this requires a restart, run the setup.sh script again."

_info "Checking if system is a mac..."
if [[ $(uname) != 'Darwin' ]]; then
  _error "You are not on a mac." && exit
else
  _ok
fi

_info "Installing all available updates..."
sudo softwareupdate -ia --verbose && _ok "installed all software updates"

_info "Checking if xcode is installed..."
if test ! "$(xcode-select -p)"; then
  xcode-select --install && _ok "installed Xcode Command Line Tools"
else
  _ok "already installed"
fi

_info "Checking for homebrew..."
if test ! "$(which brew)"; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && _info "installed Homebrew"
  brew cask install dropbox && _info "installed Dropbox"
  # Opening Dropbox to login for the first time to sync files needed for config.sh
  open -a "Dropbox" && _ok
else
  _ok "already installed"
fi
