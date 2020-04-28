#!/usr/bin/env bash

# Include library helper for colorized echo
source ./library/helper_install.sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Alfred 3                                                                    #
###############################################################################

running "Disabling Spotlight shortcuts (so Alfred can use them)"
# These changes need logout or restart to work
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{ enabled = 0; value = { parameters = ( 65535, 49, 1048576); type = standard; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "{ enabled = 0; value = { parameters = ( 32, 49, 1048576); type = standard; }; }"

running "Backing up current Alfred settings and symlinking preferred settings from Dropbox"
mv ~/Library/Application\ Support/Alfred\ 3 ~/Library/Application\ Support/Alfred\ 3_backup
ln -s ~/Dropbox/Alfred\ 3 ~/Library/Application\ Support/Alfred\ 3
ok

###############################################################################
# iTerm 2                                                                     #
###############################################################################
action "Changing iTerm settings..."

running "Disabling prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false; ok

running "Disabling changing font size with pinch gesture in iTerm"
defaults write com.googlecode.iterm2 PinchToChangeFontSizeDisabled -bool true; ok

running "Loading custom iTerm settings from dotfiles folder"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/dotfiles/config"
ok

#WARN This could break after zsh updates
running "Avoiding global globurl alias of url-quote-magic"
sudo cp ~/dotfiles/config/zsh_url-quote-magic /usr/share/zsh/5.3/functions/url-quote-magic

running "Installing color theme for iTerm (opening file)"
open "./themes/Dracula.itermcolors"; ok

###############################################################################
# mongoDB                                                                     #
###############################################################################
action "Setting up mongoDB..."
sudo mkdir -p /data/db
sudo chown -R `id -un` /data/db
ok

###############################################################################
# Tunnelblick                                                                 #
###############################################################################
running "Configuring university vpn"
open ~/Dropbox/Tunnelblick/FAU-Fulltunnel.ovpn; ok

running "Configuring work vpn"
open ~/Dropbox/Tunnelblick/ldo-TO-IPFire/ldo-TO-IPFire.ovpn; ok

###############################################################################
# Visual Studio Code                                                          #
###############################################################################
action "Setting up Visual Studio Code..."

running "Fixing VSCodeVim Key Repeat"
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

running "Installing preferred VS Code extensions"
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
  echo "$ext"
done

###############################################################################
# Kill affected applications                                                  #
###############################################################################
bot "Killing affected applications..."
for app in
  "Alfred 3" \
	"Google Chrome" \
  "iTerm" \
	"Spectacle" \
  "Visual Studio Code"; do
	killall "${app}" &> /dev/null
done
ok "Done. Note that some of these changes require a logout/restart to take effect."
