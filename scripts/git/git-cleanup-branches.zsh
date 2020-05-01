#!/bin/zsh

# Remove local branches, which do not exist on remote anymore
# e.g. feature branches, which were already merged into master

git rev-parse --is-inside-work-tree >/dev/null || return 1
git remote prune origin
# Replaced 'gone' with 'entfernt'
git branch -vv | grep 'origin/.*: entfernt]' | awk '{print $1}' | xargs git branch -D
