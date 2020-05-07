#!/bin/bash

# [I]nstall/[U]ninstall brew casks or open the [H]omepage of the app
# > Confirm with <Enter>

_cask=$(brew search --casks | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

if [ "x$_cask" != "x" ]; then
  echo "(I)nstall, (U)ninstall or open the (h)omepage of $_cask"
  read -r input
  if [ "$input" = "i" ] || [ "$input" = "I" ]; then
    brew cask install "$_cask"
  fi
  if [ "$input" = "u" ] || [ "$input" = "U" ]; then
    brew cask uninstall "$_cask"
  fi
  if [ "$input" = "h" ] || [ "$input" = "H" ]; then
    brew cask home "$_cask"
  fi
fi
