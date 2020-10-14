#!/bin/bash

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_ok()      { echo -e "\033[32m[OK]\033[0m $1" ; }
_error()   { echo -e "\033[31m[ERROR]\033[0m $1" ; }

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Mac App Store                                                               #
###############################################################################

sudo mas uninstall 409203825 || _error "failed to uninstall Numbers"
sudo mas uninstall 408981434 || _error "failed to uninstall iMovie"
sudo mas uninstall 409183694 || _error "failed to uninstall Keynote"
sudo mas uninstall 682658836 || _error "failed to uninstall Garageband"
sudo mas uninstall 409201541 || _error "failed to uninstall Pages"
