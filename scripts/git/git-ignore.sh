#!/bin/bash

# Create .gitignore file in your current directory pulled from gitignore.io

function _gi() {
  curl -L -s https://www.gitignore.io/api/"$1"
}

# Check whether current directory is a git repository
git rev-parse --is-inside-work-tree >/dev/null || exit

IFS+=","
for item in $(_gi list); do
  echo "$item"
done | fzf | paste -s -d "," - | { read -r result && _gi "$result" > ".gitignore"; }
