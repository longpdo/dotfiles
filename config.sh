#!/usr/bin/env bash

# Include library helper for colorized echo
source ./library/helper_echo.sh
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
# Google Chrome                                                               #
###############################################################################

action "Changing Google Chrome settings..."

running "Disabling the backswipe on trackpad/mouse"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
ok

running "Using the system-native print preview dialog" 
defaults write com.google.Chrome DisablePrintPreview -bool true; ok

running "Expanding print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true; ok

running "Backing up current Chrome settings and symlinking preferred settings from Dropbox"
mv ~/Library/Application\ Support/Google/Chrome/Default ~/Library/Application\ Support/Google/Chrome/Default_backup
ln -s ~/Dropbox/Google Chrome-Default ~/Library/Application\ Support/Google/Chrome/Default
ok

###############################################################################
# KeePassX                                                                    #
###############################################################################

running "Backing up current KeePassX settings and symlinking preferred settings from Dropbox"
mv ~/Library/Application\ Support/keepassx/keepassx2.ini ~/Library/Application\ Support/keepassx/keepassx2_backup.ini
ln -s ~/Dropbox/keepassx2.ini ~/Library/Application\ Support/keepassx/keepassx2.ini
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

running "Installing color theme for iTerm (opening file)"
open "./themes/Dracula.itermcolors"; ok
#open "./themes/Tomorrow Night.itermcolors"; ok

###############################################################################
# mongoDB                                                                     #
###############################################################################

action "Setting up mongoDB..."
sudo mkdir -p /data/db
sudo chown -R `id -un` /data/db
ok

###############################################################################
# Slack                                                                       #
###############################################################################

action "Installing Slack dark mode"
# Reference: https://github.com/caiceA/slack-black-theme
mv /Applications/Slack.app/contents/Resources/app.asar.unpacked/src/static/ssb-interop.js /Applications/Slack.app/contents/Resources/app.asar.unpacked/src/static/ssb-interop_backup.js
ln -s ~/dotfiles/config/slack_dark_mode.js /Applications/Slack.app/contents/Resources/app.asar.unpacked/src/static/ssb-interop.js
ok

###############################################################################
# Spectacle                                                                   #
###############################################################################

action "Backing up current Spectacle shortcuts and symlinking preferred shortcuts from dotfiles"
mv ~/Library/Application\ Support/Spectacle/Shortcuts.json ~/Library/Application\ Support/Spectacle/Shortcuts_backup.json
ln -s ~/dotfiles/config/spectacle_shortcuts.json ~/Library/Application\ Support/Spectacle/Shortcuts.json
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

running "Backing up current VSCode settings and symlinking preferred settings from Dropbox"
mv ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/Code/User/settings_backup.json
ln -s ~/dotfiles/config/vscode_settings.json ~/Library/Application\ Support/Code/User/settings.json

running "Installing preferred VS Code extensions"
CODE_EXTENSIONS=(
  # THEMES
  dracula-theme.theme-dracula
  PKief.material-icon-theme
  # FORMATTING
  CoenraadS.bracket-pair-colorizer
  formulahendry.auto-close-tag
  formulahendry.auto-rename-tag
  Gruntfuggly.todo-tree
  # PRODUCTIVITY
  alefragnani.project-manager
  christian-kohler.path-intellisense
  eamodio.gitlens
  formulahendry.code-runner
)
for ext in "$CODE_EXNTENSIONS"; do
  install_code "$ext"
done
ok

###############################################################################
# Kill affected applications                                                  #
###############################################################################

bot "Killing affected applications..."
for app in
  "Alfred 3" \
	"Google Chrome" \
  "iTerm" \
  "KeePassX" \
  "Slack" \
	"Spectacle" \
  "Visual Studio Code"; do
	killall "${app}" &> /dev/null
done
ok "Done. Note that some of these changes require a logout/restart to take effect."