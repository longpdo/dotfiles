#!/bin/bash

# Select files to unstage them from the next commit
# | with a preview showing the file with colored git diff
# > Select files with <Tab>
# > Toggle all with <Ctrl>+R
# > Confirm with <Enter>

# Check whether current directory is a git repository
git rev-parse --is-inside-work-tree >/dev/null || exit

_cmd="git diff --cached --color=always -- {} | cat "
_files="$(git diff --cached --name-only --relative | fzf --preview="$_cmd")"
[[ -n "$_files" ]] && echo "$_files" | tr '\n' '\0' | xargs -0 -I% git reset -q HEAD % && git status --short && exit

echo 'Nothing to unstage.'
