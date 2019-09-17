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
bot "Installing zsh, ohmyzsh, powerlevel9k theme..."
install_brew zsh
install_brew zsh-autosuggestions
install_brew zsh-completions
install_brew zsh-syntax-highlighting

action "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

action "Installing powerlevel9k..."
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

running "Installing the Tomorrow Night theme for iTerm (opening file)"
open "./themes/Dracula.itermcolors"
ok

running "Setting ZSH as the default shell environment"
chsh -s $(which zsh)
ok

###############################################################################
# Homebrew                                                                    #
###############################################################################
bot "Adding taps to brew..."
install_tap caskroom/versions
install_tap homebrew/cask-fonts

bot "Installing binaries, terminal stuff, CLI..."
BINARIES=(autojump bat coreutils exa fd ffmpeg findutils fzf git gnu-sed gnu-tar
  htop jq mas neovim neofetch ruby the_silver_searcher tldr tokei trash tree
  wget youtube-dl)
for brew in "${BINARIES[@]}"; do
  install_brew "$brew"
done

bot "Installing dev environment..."
DEV_ENV=(maven node mongodb)
for brew in "${DEV_ENV[@]}"; do
  install_brew "$brew"
done

bot "Installing fonts..."
install_cask font-firacode-nerd-font-mono

bot "Installing dev tool casks..."
# java8 not available anymore
DEV_TOOLS=(chromedriver intellij-idea iterm2 java java8 postman pycharm robo-3t
  visual-studio-code webstorm)
for cask in "${DEV_TOOLS[@]}"; do
  install_cask "$cask"
done

bot "Installing misc casks..."
# Dropbox was already installed via update.sh
MISC=(alfred appcleaner bitwarden google-chrome google-backup-and-sync hipchat
  iina karabiner-elements keepingyouawake mactex notion slack spectacle
  texmaker the-unarchiver tunnelblick whatsapp)
for cask in "${MISC[@]}"; do
  install_cask "$cask"
done

bot "Installing quick look plugins..."
# Reference: https://github.com/sindresorhus/quick-look-plugins/blob/master/readme.md
PLUGINS=(qlcolorcode qlstephen qlmarkdown quicklook-json betterzip
  suspicious-package webpquicklook qlvideo)
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
install_mas 836505650 # Battery Monitor: Health, Info

###############################################################################
# Other apps                                                                  #
###############################################################################
action "Downloading latest release of Portfolio Performance..."
curl -LO "$(curl -s https://api.github.com/repos/buchen/portfolio/releases/latest \
| grep browser_download_url | grep 'macosx' | head -n 1 | cut -d '"' -f 4)"

action "Unpacking tar.gz..."
tar -xzf "$(ls | grep PortfolioPerformance)" | xargs rm -r

action "Moving PortfolioPerformance to application folder..."
mv "PortfolioPerformance.app" /Applications/
ok

bot "Cleaning up..."
# Remove unused brew dependencies
brew cleanup -v
gem cleanup -v
rm "$(ls | grep PortfolioPerformance)"
ok
