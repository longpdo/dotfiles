#!/bin/zsh

# Browse through git commit log
# | with a preview showing the commit with colored git diff
# > View (less) the commit with <Enter>

git rev-parse --is-inside-work-tree >/dev/null || return 1
local cmd opts graph files
files=$(sed -nE 's/.* -- (.*)/\1/p' <<< "$*") # extract files parameters for `git show` command
cmd="echo {} |grep -Eo '[a-f0-9]+' |head -1 |xargs -I% git show --color=always % -- $files | cat"
opts="
  $FZF_DEFAULT_OPTS
  +s +m --tiebreak=index
  --bind=\"enter:execute($cmd | LESS='-R' less)\"
"
eval "git log --graph --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' $*" | FZF_DEFAULT_OPTS="$opts" fzf --preview="$cmd"
