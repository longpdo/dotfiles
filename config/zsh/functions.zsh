# Include library helper for colorized echo
source ~/dev/dotfiles/scripts/_helpers/colorized_echo.sh

# Run any command from anywhere, without leaving current working directory.
#
# Usage: `in [target] [command]`
# Target: `shtuff` target (if available), else `z` argument
# Example: `in sand art make:model -a SomeModel`

function in() {(
    j $1
    eval ${@:2}
)}

# use the command tt <tab name> to rename your tab
DISABLE_AUTO_TITLE="true"
tt () {
    echo -e "\033];$@\007"
}


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

# Open File in vscode
of() {
  local file

  file="$(rg --files $@ | fzf -0 -1 | awk -F: '{print $1}')"

  if [[ -n $file ]]
  then
     code $file
  fi
}

# Open dir in vscode
od() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&

  if [[ -n $dir ]]
  then
     code "$dir"
  fi
}

# cD to selected dir fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}


# cdf - cd into the directory of the selected file
cdff() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# Use z to jump with fzf
jj() {
  cd "$(z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q "$_last_z_args")"
}
