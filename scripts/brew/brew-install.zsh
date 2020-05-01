#!/bin/zsh

# Install (one or multiple) selected brew packages

local inst=$(brew search | fzf -m)

if [[ $inst ]]; then
  for prog in $(echo $inst);
  do; brew install $prog; done;
fi
