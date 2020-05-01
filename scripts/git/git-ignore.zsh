#!/bin/zsh

# Create .gitignore file in your current directory pulled from gitignore.io

function __gi() {
  curl -L -s https://www.gitignore.io/api/"$@"
}

git rev-parse --is-inside-work-tree >/dev/null || return 1

if  [ "$#" -eq 0 ]; then
  IFS+=","
  for item in $(__gi list); do
    echo $item
  done | fzf --multi --ansi | paste -s -d "," - |
  { read result && __gi "$result"; }
else
  __gi "$@"
fi
