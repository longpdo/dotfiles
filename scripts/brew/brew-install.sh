#!/bin/bash

# Install selected brew packages
# > Select files with <Tab>
# > Confirm with <Enter>

_selected=$(brew formulae | fzf -m)

if [[ $_selected ]]; then
  for brew in $_selected; do
    brew install "$brew"
  done
fi
