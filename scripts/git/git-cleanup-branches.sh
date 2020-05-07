#!/bin/bash

# Remove local branches, which do not exist on remote anymore
# e.g. feature branches, which were already merged into master

# Check whether current directory is a git repository
git rev-parse --is-inside-work-tree >/dev/null || exit

git remote prune origin
# Replaced 'gone' with 'entfernt'
git branch -vv | grep 'origin/.*: entfernt]' | awk '{print $1}' | xargs git branch -D
