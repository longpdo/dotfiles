#!/bin/bash

# Analyse all shell scripts with ShellCheck

_SCRIPTS_PATH="$DOTFILES_PATH/scripts/"

for script in $(rg -t sh --files "$_SCRIPTS_PATH"); do
  shellcheck "$script"
done
