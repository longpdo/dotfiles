#!/bin/bash

# [I]nstall/[U]ninstall brew casks or open the [H]omepage of the app
# > Confirm with <Enter>

_cask=$(brew casks | tail -n +2 | fzf-tmux --query="$1" +m --preview 'brew info --cask {}')

if [ "x$_cask" != "x" ]; then
  echo "(I)nstall, (U)ninstall or open the (h)omepage of $_cask"
  read -r input
  if [ "$input" = "i" ] || [ "$input" = "I" ]; then
    brew install --cask "$_cask"
  fi
  if [ "$input" = "u" ] || [ "$input" = "U" ]; then
    brew uninstall --cask "$_cask"
  fi
  if [ "$input" = "h" ] || [ "$input" = "H" ]; then
    brew home --cask "$_cask"
  fi
fi
