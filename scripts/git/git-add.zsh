#!/bin/zsh

# Add files to git version control
# | with a preview showing the file with colored git diff
# > Select files with <Tab>
# > Toggle all with <Ctrl>+R
# > Confirm with <Enter>

git rev-parse --is-inside-work-tree >/dev/null || return 1

local changed unmerged untracked files opts preview extract
changed=$(git config --get-color color.status.changed red)
unmerged=$(git config --get-color color.status.unmerged red)
untracked=$(git config --get-color color.status.untracked red)
extract="
  sed 's/^.*]  //' |
  sed 's/.* -> //' |
  sed -e 's/^\\\"//' -e 's/\\\"\$//'"
preview="
  file=\$(echo {} | $extract)
  if (git status -s -- \$file | grep '^??') &>/dev/null; then  # diff with /dev/null for untracked files
    git diff --color=always --no-index -- /dev/null \$file | cat | sed '2 s/added:/untracked:/'
  else
    git diff --color=always -- \$file | cat
  fi"
opts="
  $FZF_DEFAULT_OPTS
  -0 -m --nth 2..,..
"
files=$(git -c color.status=always -c status.relativePaths=true status -su |
  grep -F -e "$changed" -e "$unmerged" -e "$untracked" |
  sed -E 's/^(..[^[:space:]]*)[[:space:]]+(.*)$/[\1]  \2/' |
  FZF_DEFAULT_OPTS="$opts" fzf --preview="$preview" |
  sh -c "$extract")

[[ -n "$files" ]] && echo "$files"| tr '\n' '\0' |xargs -0 -I% git add % && git status -su && return
echo 'Nothing to add.'
