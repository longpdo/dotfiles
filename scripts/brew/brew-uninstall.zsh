#!/bin/zsh

# Uninstall selected brew packages
# > Select files with <Tab>
# > Confirm with <Enter>

local uninst=$(brew leaves | fzf -m)

if [[ $uninst ]]; then
  for prog in $(echo $uninst);
  do; brew uninstall $prog; done;
fi
