#!/bin/bash

# Show changes of current modified files to their version at HEAD
# > View (less) the file with <Enter>

# Check whether current directory is a git repository
git rev-parse --is-inside-work-tree >/dev/null || exit

[[ $# -ne 0 ]] && {
  if git rev-parse "$1" -- &>/dev/null ; then
    _commit="$1" && _files=("${@:2}")
  else
    _files=("$@")
  fi
}
_repo="$(git rev-parse --show-toplevel)"
_cmd="echo {} | sed 's/.*]  //' | xargs -I% git diff --color=always $_commit -- '$_repo/%' | cat"
_opts="$FZF_DEFAULT_OPTS +m -0 --bind=\"enter:execute($_cmd |LESS='-R' less)\""

eval "git diff --name-status $_commit -- ${_files[*]} | sed -E 's/^(.)[[:space:]]+(.*)$/[\1]  \2/'" | FZF_DEFAULT_OPTS="$_opts" fzf --preview="$_cmd"
