#!/bin/zsh

# Install selected brew packages
# > Select files with <Tab>
# > Confirm with <Enter>

local inst=$(brew search | fzf -m)

if [[ $inst ]]; then
  for prog in $(echo $inst);
  do; brew install $prog; done;
fi
