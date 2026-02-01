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
  timonwong.shellcheck
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