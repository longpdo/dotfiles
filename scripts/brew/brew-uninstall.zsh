#!/bin/zsh

# Delete (one or multiple) selected brew packages

local uninst=$(brew leaves | fzf -m)

if [[ $uninst ]]; then
  for prog in $(echo $uninst);
  do; brew uninstall $prog; done;
fi
