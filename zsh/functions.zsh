#like normal autojump when used with arguments but displays an fzf prompt when used without
function j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sed '/_____/Q; s/^[0-9,.:]*\s*//' | sort -r | fzf --height 40% --reverse --inline-info)"
}

# search through zsh command history with fzf
function history() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# git checkout branch with fzf (including remote branches)
function gco() {
  local branches target
  branches=$(
    git branch --all | grep -v HEAD |
    sed "s/.* //" |
    sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches") |
    fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
        --ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
  git checkout $(echo "$target" | awk '{print $2}' | sed "s#remotes/[^/]*/##")
}

# fshow - git commit browser
function glog() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | diff-so-fancy | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

function mkd {
  mkdir -p "$@" && cd "$_";
}

function update() {
  sudo -v
  # Keep-alive: update existing sudo time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  # Installing all available updates
  sudo softwareupdate -ia --verbose
  # Updating homebrew and packages
  brew update
  brew upgrade
  # Upgrading brew cask packages
  brew cask outdated
  brew cask upgrade
  # Upgrading App Store apps
  mas outdated
  mas upgrade
  # Updating ruby gems
  gem update
  # Cleaning up
  brew bundle dump
  brew bundle --force cleanup
  brew cleanup -v
  gem cleanup -v
  # Recursively delete `.DS_Store` files
  find . -type f -name '*.DS_Store' -ls -delete
}

function wifi() {
  airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
  ssid=$($airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
  pw=$(security find-generic-password -D 'AirPort network password' -ga $ssid 2>&1 >/dev/null)
  echo $(echo "$pw" | sed -e "s/^.*\"\(.*\)\".*$/\1/")
}

function yt() {
  youtube-dl $1 -o "~/Downloads/%(title)s.%(ext)s"
}
