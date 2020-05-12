#!/bin/bash

# Script cleaning up tmp files

# Log Helper
_info() { echo -e "\033[1m[INFO]\033[0m $1" ; }

_info "Cleaning up brew packages"
brew bundle dump
brew bundle --force cleanup
brew cleanup -v
rm Brewfile

_info "Cleaning up ruby gems"
gem cleanup -v

_info "Deleting .DS_Store files"
find . -type f -name '*.DS_Store' -ls -delete
