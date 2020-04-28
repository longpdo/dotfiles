#!/usr/bin/env bash

# Include library helper for colorized echo
source ./library/helper_echo.sh
source ./library/helper_install.sh

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# ZSH                                                                         #
###############################################################################
bot "Installing zsh..."
install_brew zsh

action "Installing antibody..."
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

running "Installing the Tomorrow Night theme for iTerm (opening file)"
open "./themes/Dracula.itermcolors"
ok

running "Setting ZSH as the default shell environment"
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
ok

###############################################################################
# Homebrew                                                                    #
###############################################################################
bot "Adding taps to brew..."
install_tap caskroom/versions
install_tap homebrew/cask-fonts

bot "Installing binaries, terminal stuff, CLI..."
BINARIES=(
  autojump
  bat
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
  rename
  ripgrep
  ruby
  scrcpy
  the_silver_searcher
  tldr
  tokei
  trash
  wget
  youtube-dl
)
for brew in "${BINARIES[@]}"; do
  install_brew "$brew"
done

bot "Installing dev environment..."
DEV_ENV=(
  maven
  node
  mongodb
)
for brew in "${DEV_ENV[@]}"; do
  install_brew "$brew"
done

bot "Installing fonts..."
install_cask font-firacode-nerd-font-mono

bot "Installing dev tool casks..."
DEV_TOOLS=(
  android-studio
  chromedriver
  insomnia
  intellij-idea
  iterm2
  java
  #java8 -> not available anymore
  pycharm
  robo-3t
  visual-studio-code
  webstorm
)
for cask in "${DEV_TOOLS[@]}"; do
  install_cask "$cask"
done

bot "Installing misc casks..."
# Dropbox was already installed via update.sh
MISC=(
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
  mactex-no-gui
  mkvtoolnix
  musicbrainz-picard
  notion
  slack
  spectacle
  the-unarchiver
  tunnelblick
  whatsapp
  zoomus
)
for cask in "${MISC[@]}"; do
  install_cask "$cask"
done

bot "Installing quick look plugins..."
# Reference: https://github.com/sindresorhus/quick-look-plugins/blob/master/readme.md
PLUGINS=(
  qlcolorcode
  qlstephen
  qlmarkdown
  quicklook-json
  qlvideo
)
for cask in "${PLUGINS[@]}"; do
  install_cask "$cask"
done

###############################################################################
# npm                                                                         #
###############################################################################
bot "Installing npm packages..."
install_npm @angular/cli
install_npm fkill-cli
install_npm typescript

###############################################################################
# Ruby                                                                        #
###############################################################################
bot "Installing ruby packages..."
install_gem_local bundler
install_gem_local jekyll

###############################################################################
# Mac App Store                                                               #
###############################################################################
bot "Installing apps from App Store..."
install_mas 497799835 # Xcode

###############################################################################
# Other apps                                                                  #
###############################################################################
action "Downloading latest release of Portfolio Performance..."
curl -LO "$(curl -s https://api.github.com/repos/buchen/portfolio/releases/latest \
| grep browser_download_url | grep '.dmg' | head -n 1 | cut -d '"' -f 4)"

action "Downloading latest release of subsync..."
curl -LO "$(curl -s https://api.github.com/repos/sc0ty/subsync/releases \
| grep browser_download_url | grep 'mac' | head -n 1 | cut -d '"' -f 4)"

bot "Cleaning up..."
# Remove unused brew dependencies
brew cleanup -v
gem cleanup -v
rm "$(ls | grep PortfolioPerformance)"
ok
