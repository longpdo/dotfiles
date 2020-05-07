#!/bin/bash

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_ok()      { echo -e "\033[32m[OK]\033[0m $1" ; }
error()   { echo -e "\033[31m[ERROR]\033[0m $1" ; }

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Alfred 3                                                                    #
###############################################################################

_info "Disabling Spotlight shortcuts (so Alfred can use them)"
# These changes need logout or restart to work
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{ enabled = 0; value = { parameters = ( 65535, 49, 1048576); type = standard; }; }" || _error "defaults write com.apple.symbolichotkeys"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "{ enabled = 0; value = { parameters = ( 32, 49, 1048576); type = standard; }; }" || _error "defaults write com.apple.symbolichotkeys"

_info "Backing up current Alfred settings and symlinking preferred settings from Dropbox"
mv ~/Library/Application\ Support/Alfred\ 3 ~/Library/Application\ Support/Alfred\ 3_backup || _error "backing up Alfred settings"
ln -s ~/Dropbox/Alfred\ 3 ~/Library/Application\ Support/Alfred\ 3 || _error "symlinking Alfred settings"

###############################################################################
# iTerm 2                                                                     #
###############################################################################
_info "Changing iTerm settings..."

_info "Disabling prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false || _error "defaults write com.googlecode.iterm2"

_info "Disabling changing font size with pinch gesture in iTerm"
defaults write com.googlecode.iterm2 PinchToChangeFontSizeDisabled -bool true || _error "defaults write com.googlecode.iterm2"

#WARN This could break after zsh updates
_info "Avoiding global globurl alias of url-quote-magic"
sudo cp "$HOME/dev/dotfiles/config/iTerm2/zsh_url-quote-magic" "/usr/share/zsh/5.3/functions/url-quote-magic" || _error "overwriting url-quote-magic"

_info "Installing color theme for iTerm (opening file)"
open "$HOME/dev/dotfiles/config/iTerm2/Dracula.itermcolors" && _ok

###############################################################################
# mongoDB                                                                     #
###############################################################################
_info "Setting up mongoDB..."
sudo mkdir -p /data/db && sudo chown -R "$(id -un)" /data/db && _ok

###############################################################################
# Tunnelblick                                                                 #
###############################################################################
_info "Configuring university vpn"
open "$HOME/Dropbox/Tunnelblick/FAU-Fulltunnel.ovpn" && _ok

_info "Configuring work vpn"
open "$HOME/Dropbox/Tunnelblick/ldo-TO-IPFire/ldo-TO-IPFire.ovpn" && _ok

###############################################################################
# Visual Studio Code                                                          #
###############################################################################
_info "Setting up Visual Studio Code..."

_info "Fixing VSCodeVim Key Repeat"
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false || _error "defaults write com.microsoft.VSCode"

_info "Installing preferred VS Code extensions"
CODE_EXTENSIONS=(
  johnpapa.angular2
  formulahendry.auto-close-tag
  formulahendry.auto-rename-tag
  CoenraadS.bracket-pair-colorizer
  formulahendry.code-runner
  streetsidesoftware.code-spell-checker
  pranaygp.vscode-css-peek
  dracula-theme.theme-dracula
  dbaeumer.vscode-eslint
  michelemelluso.gitignore
  eamodio.gitlens
  ecmel.vscode-html-css
  k--kato.intellij-idea-keybindings
  xabikos.javascriptsnippets
  james-yu.latex-workshop
  ritwickdey.liveserver
  yzhang.markdown-all-in-one
  davidanson.vscode-markdownlint
  PKief.material-icon-theme
  metaseed.metago
  christian-kohler.path-intellisense
  remimarsal.prettier-now
  alefragnani.project-manager
  ms-python.python
  albert.tabout
  gruntfuggly.todo-tree
  ms-vscode.vscode-typescript-tslint-plugin
  chakrounanas.turbo-console-log
  wakatime.vscode-wakatime
)
for ext in "${CODE_EXTENSIONS[@]}"; do
  _info "installing $ext"
  code --install-extension "$ext" || _error "failed installing $ext"
done

###############################################################################
# Kill affected applications                                                  #
###############################################################################
_info "Killing affected applications..."
for app in "Alfred 3" "iTerm" "Visual Studio Code"; do
	killall "${app}" &> /dev/null
done
_ok "Done. Note that some of these changes require a logout/restart to take effect."
