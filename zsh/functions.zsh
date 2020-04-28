# Include library helper for colorized echo
source ~/dotfiles/library/helper_echo.sh
source ~/dotfiles/library/helper_install.sh

function cd_to_current_finder_window() {
  cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
}

# Automatically ls when changing directories in zsh
chpwd() {
  ls
}

function create_dir_and_cd_to_it {
  mkdir -p "$@" && cd "$_";
}

function convert_audio_flac_to_aac_vbr_5 {
  find . -name '*.flac' -exec sh -c 'ffmpeg -i "$1" -c:v copy -c:a libfdk_aac -vbr 5 "${1%.flac}.m4a"' _ {} \;
}

function download_youtube_video() {
  youtube-dl $1 -o "~/Downloads/%(title)s.%(ext)s"
}

function get_wifi_password() {
  airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
  ssid=$($airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
  pw=$(security find-generic-password -D 'AirPort network password' -ga $ssid 2>&1 >/dev/null)
  echo $(echo "$pw" | sed -e "s/^.*\"\(.*\)\".*$/\1/")
}

function git_open_repo_in_browser() {
  open $(git config remote.origin.url | sed 's/.\{4\}$//')/$1$2
}

function git_checkout_branch_with_fzf() {
  git rev-parse --is-inside-work-tree >/dev/null || return 1
  local branches target
  branches=$(
    git branch --all | grep -v HEAD |
    sed "s/.* //" |
    sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches") |
    fzf --height 40% --no-hscroll --no-multi --delimiter="\t" -n 2 \
        --ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
  git checkout $(echo "$target" | awk '{print $2}' | sed "s#remotes/[^/]*/##")
  git pull
}

function git_clean_branches() {
  git rev-parse --is-inside-work-tree >/dev/null || return 1
  git remote prune origin
  # Replaced 'gone' with 'entfernt'
  git branch -vv | grep 'origin/.*: entfernt]' | awk '{print $1}' | xargs git branch -D
}

function git_commit_log_with_fzf() {
  git rev-parse --is-inside-work-tree >/dev/null || return 1
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --height 80% \
      --preview="echo {} | grep -Eo '[a-f0-9]+' | head -1 | xargs -I% git show --color=always % | diff-so-fancy" \
      --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute: (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R')<< 'FZF-EOF'{} FZF-EOF"
}

function jump_to_given_dir_or_with_fzf() {
  if [[ "$#" -ne 0 ]]; then
    cd $(autojump $@)
    return
  fi
  cd "$(autojump -s | sed '/_____/Q; s/^[0-9,.:]*\s*//' | sort -r | fzf --height 40% --inline-info)"
}

function open_arg_in_vs_code {
  local argPath="$1"
  [[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
  open -a "Visual Studio Code" "$argPath"
}

function update_all_and_cleanup() {
  sudo -v
  bot "Starting update script..."
  action "Installing all available updates"
  sudo softwareupdate -ia --verbose
  action "Updating antibody plugins"
  antibody update
  action "Updating homebrew and packages"
  brew update
  brew upgrade
  action "Upgrading brew cask packages"
  brew cask outdated
  brew cask upgrade
  action "Upgrading App Store apps"
  mas outdated
  mas upgrade
  action "Updating ruby gems"
  gem update
  bot "Cleaning up..."
  action "Cleaning up brew packages"
  brew bundle dump
  brew bundle --force cleanup
  brew cleanup -v
  rm Brewfile
  action "Cleaning up ruby gems"
  gem cleanup -v
  action "Deleting `.DS_Store` files"
  find . -type f -name '*.DS_Store' -ls -delete
  action "Backing up application settings with mackup"
  mackup backup
}

function zsh_history_with_fzf() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --height 40% --tac | sed 's/ *[0-9]* *//')
}
