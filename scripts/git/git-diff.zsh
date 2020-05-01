#!/bin/zsh

# Show changes of current modified files to their version at HEAD
# > View (less) the file with <Enter>

git rev-parse --is-inside-work-tree >/dev/null || return 1
local cmd files opts commit repo
[[ $# -ne 0 ]] && {
  if git rev-parse "$1" -- &>/dev/null ; then
    commit="$1" && files=("${@:2}")
  else
    files=("$@")
  fi
}

repo="$(git rev-parse --show-toplevel)"
cmd="echo {} |sed 's/.*]  //' |xargs -I% git diff --color=always $commit -- '$repo/%' | cat"
opts="
  $FZF_DEFAULT_OPTS
  +m -0 --bind=\"enter:execute($cmd |LESS='-R' less)\"
"
eval "git diff --name-status $commit -- ${files[*]} | sed -E 's/^(.)[[:space:]]+(.*)$/[\1]  \2/'" | FZF_DEFAULT_OPTS="$opts" fzf --preview="$cmd"
