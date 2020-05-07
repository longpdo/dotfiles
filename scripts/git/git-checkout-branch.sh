#!/bin/bash

# Checkout selected branch from a list of local and remote branches
# | with a preview showing the commits between the branch and HEAD

_branches=$(
  git --no-pager branch --all \
  --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
  | sed '/^$/d') || exit
_tags=$(git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || exit
_target=$(
  (echo "$_branches"; echo "$_tags") |
  fzf --no-hscroll --no-multi -n 2 --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || exit

git checkout "$(awk '{print $2}' <<<"$_target" )"
