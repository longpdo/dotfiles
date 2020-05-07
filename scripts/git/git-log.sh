#!/bin/bash

# Browse through git commit log
# | with a preview showing the commit with colored git diff
# > View (less) the commit with <Enter>

# Check whether current directory is a git repository
git rev-parse --is-inside-work-tree >/dev/null || exit

_files=$(sed -nE 's/.* -- (.*)/\1/p' <<< "$*") # extract files parameters for `git show` command
_cmd="echo {} |grep -Eo '[a-f0-9]+' |head -1 |xargs -I% git show --color=always % -- $_files | cat"
_opts="$FZF_DEFAULT_OPTS +s +m --tiebreak=index --bind=\"enter:execute($_cmd | LESS='-R' less)\""

eval "git log --graph --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' $*" | FZF_DEFAULT_OPTS="$_opts" fzf --preview="$_cmd"
