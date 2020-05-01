#!/bin/zsh

# Select files to unstage them from the next commit
# | with a preview showing the file with colored git diff
# > Select files with <Tab>
# > Toggle all with <Ctrl>+R
# > Confirm with <Enter>

git rev-parse --is-inside-work-tree >/dev/null || return 1
local cmd files opts
cmd="git diff --cached --color=always -- {} | cat "
files="$(git diff --cached --name-only --relative | fzf --preview="$cmd")"
[[ -n "$files" ]] && echo "$files" | tr '\n' '\0' | xargs -0 -I% git reset -q HEAD % && git status --short && return
echo 'Nothing to unstage.'
