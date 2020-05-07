#!/bin/bash

# Uninstall selected brew packages
# > Select files with <Tab>
# > Confirm with <Enter>

_selected=$(brew leaves | fzf -m)

if [[ $_selected ]]; then
  for brew in $_selected; do
    brew uninstall "$brew"
  done
fi
