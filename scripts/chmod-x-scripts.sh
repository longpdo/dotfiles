#!/bin/bash

# Change scripts with 644 permissions to 755 permissions

# Log Helper
_ok() { echo -e "\033[32m[OK]\033[0m $1" ; }

_SCRIPTS_PATH='/Users/longdo/dev/dotfiles/scripts/'

for script in $(rg -t sh --files $_SCRIPTS_PATH); do
  [[ $(stat -f "%OLp" "$script") == '644' ]] && chmod +x "$script" && _ok "$script"
done
