# ------------------------------------------------------------
# aliases
# ------------------------------------------------------------

# Easier navigation: .., ..., ...., .....
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'

# better cd
if command -v zoxide &> /dev/null; then
  alias cd="zd"
  zd() {
    if [ $# -eq 0 ]; then
      builtin cd ~ && return
    elif [ -d "$1" ]; then
      builtin cd "$1"
    else
      z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
    fi
  }
fi

# Automatically ls when changing directories in zsh
chpwd() {
  ls
}

# better ls
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

# Aliases replacing common apps with better alternatives
alias cat='bat --paging=never'
alias cp='cp -v'
alias mv='mv -v'
alias rm='trash -v'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias whereami='pwd'

# Shortcuts
alias fuck='sudo !!'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias finder='open .'
open() {
  if command -v open >/dev/null; then
    command open "$@" >/dev/null 2>&1 &
  elif command -v xdg-open >/dev/null; then
    xdg-open "$@" >/dev/null 2>&1 &
  fi
}

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# Functions
alias mkd='create_dir_and_cd_to_it'
create_dir_and_cd_to_it() {
  mkdir -p "$1" && cd "$1"
}


# Run any command from anywhere, without leaving current working directory.
#
# Usage: `in [target] [command]`
# Target: `shtuff` target (if available), else `z` argument
# Example: `in sand art make:model -a SomeModel`
in() (
  local target="$1"
  shift || true

  if [ -z "$target" ]; then
    echo "Usage: in <dir|zoxide-query> <command...>" >&2
    return 1
  fi

  if [ -d "$target" ]; then
    cd "$target" || return 1
  elif command -v z >/dev/null 2>&1; then
    z "$target" || return 1
  else
    echo "No such directory and no zoxide (z) available" >&2
    return 1
  fi

  "$@"
)

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ "$#" -lt 1 ]; then
    echo "Need a string to search for!" >&2
    return 1
  fi

  local q="$1"
  rg --files-with-matches --no-messages --ignore-case "$q" |
    fzf --preview "rg --ignore-case --pretty --context 10 -- '$q' {} | (command -v bat >/dev/null 2>&1 && bat --style=numbers --color=always --paging=never {} || cat {})"
}

# Use z to jump with fzf
jj() {
  command -v z >/dev/null 2>&1 || { echo "zoxide (z) not found" >&2; return 1; }
  local dir
  dir="$(z -l 2>/dev/null | sed 's/^[0-9,.]* *//' | fzf)" || return 1
  cd "$dir"
}

# CTRL-X
# Resolve this file's real location (follows symlinks), then derive dotfiles root.
ALIASES_REALPATH="$(realpath "${(%):-%N}")"
export DOTFILES_DIR="$(cd "$(dirname "$ALIASES_REALPATH")/../../.." && pwd)"
fzf-script-launcher() {
  local SCRIPTS_PATH="$DOTFILES_DIR/scripts"

  local selected
  selected="$(
    rg -t sh --files "$SCRIPTS_PATH" |
      sed "s|^$SCRIPTS_PATH||" |
      fzf --height 40% --preview "bat --style=grid --color=always '$SCRIPTS_PATH{}'" -q "$LBUFFER"
  )" || return

  LBUFFER="$SCRIPTS_PATH$selected"
  zle redisplay
}

zle -N fzf-script-launcher
bindkey '^X' fzf-script-launcher
