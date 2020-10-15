#!/bin/bash

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_ok()      { echo -e "\033[32m[OK]\033[0m $1" ; }
_error()   { echo -e "\033[31m[ERROR]\033[0m $1" ; }

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# ZSH                                                                         #
###############################################################################
_info "Installing zsh..."
brew install zsh || _error "failed installing zsh"

_info "Installing antibody..."
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

_info "Installing the Tomorrow Night theme for iTerm (opening file)"
open "./themes/Dracula.itermcolors" && _ok ""

_info "Setting ZSH as the default shell environment"
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s "$(which zsh)" && _ok ""

###############################################################################
# Homebrew                                                                    #
###############################################################################
_info "Adding taps to brew..."
brew tap homebrew/cask-versions || _error "failed brew tap homebrew/cask-versions"
brew tap homebrew/cask-fonts || _error "failed brew tap homebrew/cask-fonts"
brew tap AdoptOpenJDK/openjdk || _error "failed brew tap AdoptOpenJDK/openjdk"

_info "Installing binaries, terminal stuff, CLI..."
_BINARIES=(
  bat
  exa
  coreutils
  exa
  fd
  # homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac\n
  ffmpeg
  findutils
  fzf
  git
  jq
  mackup
  mas
  media-info
  neovim
  neofetch
  ocrmypdf
  pdfgrep
  rename
  ripgrep
  ruby
  scrcpy
  tesseract-lang # language packs for ocr
  tldr
  tokei
  trash
  wget
  youtube-dl
)
for brew in "${_BINARIES[@]}"; do
  _info "installing $brew"
  brew install "$brew" || error "failed brew install $brew"
done

# TODO add pipx install
# pigar
# flake8

_info "Installing dev environment..."
_DEV_LIBRARIES=(
  jenv
  lua
  maven
  node
)
for brew in "${_DEV_LIBRARIES[@]}"; do
  _info "installing $brew"
  brew install "$brew" || error "failed brew install $brew"
done

_info "Installing fonts..."
brew cask install font-hack-nerd-font || error "failed installing fonts"

_info "Installing dev tool casks..."
_DEV_CASKS=(
  adoptopenjdk8
  chromedriver
  insomnia
  intellij-idea
  iterm2
  pycharm
  robo-3t
  visual-studio-code
  webstorm
)
for cask in "${_DEV_CASKS[@]}"; do
  _info "installing $cask"
  brew cask install "$cask" || error "failed brew cask install $cask"
done

_info "Installing misc casks..."
# Dropbox was already installed via update.sh
_MISC_CASKS=(
  alfred
  android-platform-tools
  appcleaner
  bitwarden
  firefox-developer-edition
  google-chrome
  google-backup-and-sync
  handbrake
  iina
  jdownloader
  kap
  karabiner-elements
  kodi
  losslesscut
  mactex-no-gui
  mkvtoolnix
  musicbrainz-picard
  notion
  slack
  spectacle
  the-unarchiver
  ticktick
  tunnelblick
  whatsapp
  zoomus
)
for cask in "${_MISC_CASKS[@]}"; do
  _info "installing $cask"
  brew cask install "$cask" || error "failed brew cask install $cask"
done

_info "Installing quick look plugins..."
# Reference: https://github.com/sindresorhus/quick-look-plugins/blob/master/readme.md
_PLUGINS=(
  qlcolorcode
  qlstephen
  qlmarkdown
  quicklook-json
  qlvideo
)
for cask in "${_PLUGINS[@]}"; do
  _info "installing $cask"
  brew cask install "$cask" || error "failed brew cask install $cask"
done

###############################################################################
# npm                                                                         #
###############################################################################
_info "Installing npm packages..."
npm install -g @angular/cli || _error "failed npm install @angular/cli"
npm install -g fkill-cli || _error "failed npm install fkill-cli"
npm install -g typescript || _error "failed npm install typescript"

###############################################################################
# Ruby                                                                        #
###############################################################################
_info "Installing ruby packages..."
gem install --user-install bundler || _error "failed gem install bundler"
gem install --user-install jekyll || _error "failed gem install jekyll"

###############################################################################
# Mac App Store                                                               #
###############################################################################
_info "Installing apps from App Store..."
mas install 497799835 || _error "failed mas install Xcode" # Xcode

###############################################################################
# Other apps                                                                  #
###############################################################################
cd ~/Downloads && _info "changed directory to ~/Downloads"

_info "Downloading latest release of Portfolio Performance..."
curl -LO "$(curl -s https://api.github.com/repos/buchen/portfolio/releases/latest | grep browser_download_url | grep '.dmg' | head -n 1 | cut -d '"' -f 4)" || _error "failed curl of Porfolio Performance"

_info "Downloading latest release of subsync..."
curl -LO "$(curl -s https://api.github.com/repos/sc0ty/subsync/releases | grep browser_download_url | grep 'mac' | head -n 1 | cut -d '"' -f 4)" || _error "failed curl of subsync"

cd - && _info "changed directory back to original location"

_info "Cleaning up..."
# Remove unused brew dependencies
brew cleanup -v && _ok ""
gem cleanup -v && _ok ""
