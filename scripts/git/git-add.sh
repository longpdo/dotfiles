#!/bin/bash

# Add files to git version control
# | with a preview showing the file with colored git diff
# > Select files with <Tab>
# > Toggle all with <Ctrl>+R
# > Confirm with <Enter>

_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }

# Check whether current directory is a git repository
git rev-parse --is-inside-work-tree >/dev/null || exit

_changed=$(git config --get-color color.status.changed red)
_unmerged=$(git config --get-color color.status.unmerged red)
_untracked=$(git config --get-color color.status.untracked red)
_extract="
  sed 's/^.*]  //' |
  sed 's/.* -> //' |
  sed -e 's/^\\\"//' -e 's/\\\"\$//'"
_preview="
  file=\$(echo {} | $_extract)
  if (git status -s -- \$file | grep '^??') &>/dev/null; then  # diff with /dev/null for untracked files
    git diff --color=always --no-index -- /dev/null \$file | cat | sed '2 s/added:/untracked:/'
  else
    git diff --color=always -- \$file | cat
  fi"
_opts="$FZF_DEFAULT_OPTS -0 -m --nth 2..,.."
_files=$(git -c color.status=always -c status.relativePaths=true status -su |
  grep -F -e "$_changed" -e "$_unmerged" -e "$_untracked" |
  sed -E 's/^(..[^[:space:]]*)[[:space:]]+(.*)$/[\1]  \2/' |
  FZF_DEFAULT_OPTS="$_opts" fzf --preview="$_preview" |
  sh -c "$_extract")

# On user selection, git add selected files
[[ -n "$_files" ]] && echo "$_files" | tr '\n' '\0' | xargs -0 -I% git add % && git status -su && exit

_info 'Nothing to add.'
