#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

main() {
  require_macos
  
  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing sudo time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  read -r -p "Do you want to change your computer and host name? [y|N] " response
  if [[ $response =~ (yes|y|Y) ]];then
    read -r -p "Computer: change $(sudo scutil --get ComputerName) to: " _computer_name
    sudo scutil --set ComputerName "$_computer_name" && changed "changed computer name"
    read -r -p "Localhost: change $(sudo scutil --get LocalHostName) to: " _local_host_name
    sudo scutil --set LocalHostName "$_local_host_name" && changed "changed host name"
  else
    ok "skipped";
  fi

  log "Closing any open System Preferences panes..."
  osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

  ###############################################################################
  # General                                                                     #
  ###############################################################################

  log "Disabling the sound effects on boot"
  sudo nvram SystemAudioVolume=" " || warn "no NVRAM access; skipped"

  log "Disabling the crash reporter"
  defaults write com.apple.CrashReporter DialogType -string "none" || fail ""
  
  log "Changing scrollbars to Always"
  defaults write NSGlobalDomain AppleShowScrollBars -string "Always" || fail ""

  log "Disabling automatic termination of inactive apps"
  defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true || fail ""

  log "Saving to disk (not to iCloud) by default"
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false || fail ""

  ###############################################################################
  # Security                                                                    #
  ###############################################################################
  log "Changing Security settings..."

  log "Enabling Firewall"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on || fail ""

  #log "Blocking all incoming connections"
  #sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on || fail ""

  #log "Restarting automatically if the computer freezes"
  #sudo systemsetup -setrestartfreeze on || fail ""

  log "Disabling remote apple events"
  sudo systemsetup -setremoteappleevents off || warn "Needs Full Disk Access; skipped"

  log "Disabling remote login"
  sudo systemsetup -setremotelogin off || fail ""

  log "Disabling wake-on LAN"
  sudo systemsetup -setwakeonnetworkaccess off || fail ""

  ###############################################################################
  # Keyboard                                                                    #
  ###############################################################################
  log "Changing Keyboard settings..."

  log "Enabling full keyboard access for all controls"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 || fail ""

  log "Disabling press-and-hold for keys in favor of key repeat"
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false || fail ""

  log "Setting fast keyboard repeat rate"
  defaults write NSGlobalDomain KeyRepeat -int 2 || fail ""
  defaults write NSGlobalDomain InitialKeyRepeat -int 12 || fail ""

  log "Disabling automatic capitalization"
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false || fail ""

  log "Disabling smart dashes"
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false || fail ""

  log "Disabling automatic period substitution"
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false || fail ""

  log "Disabling smart quotes"
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false || fail ""

  log "Disabling auto-correct"
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false || fail ""

  ###############################################################################
  # Mouse                                                                       #
  ###############################################################################
  log "Changing Mouse settings..."

  log "Setting mouse tracking speed"
  defaults write -g com.apple.mouse.scaling -float 3.0 || fail ""

  ###############################################################################
  # Trackpad                                                                    #
  ###############################################################################
  log "Changing Trackpad settings..."

  log "Setting trackpad tracking speed"
  defaults write -g com.apple.trackpad.scaling -float 2.0 || fail ""

  log "Enabling trackpad tap to click"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true || fail ""
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 || fail ""
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 || fail ""

  log "Mapping trackpad bottom right corner to right-click"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2 || fail ""
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true || fail ""
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1 || fail ""
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true || fail ""

  log "Disabling 'natural' scrolling"
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false || fail ""

  ###############################################################################
  # Printer & Scanner                                                           #
  ###############################################################################
  log "Changing Printer & Scanner settings..."

  log "Expanding save and print panel by default"
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true || fail ""
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true || fail ""
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true || fail ""
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true || fail ""

  log "Automatically quit printer app once the print jobs complete"
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true || fail ""

  ###############################################################################
  # Time Machine                                                                #
  ###############################################################################
  log "Changing Time Machine settings..."

  log "Preventing Time Machine to use new hard drives as backup volume"
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true || fail ""

  log "Disable automatic Time Machine backups"
  hash tmutil &> /dev/null && sudo tmutil disable || fail ""

  ###############################################################################
  # Booting, Login Window                                                       #
  ###############################################################################
  log "Disabling guest account login"
  sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false || fail ""

  log "Showing language menu in the top right corner of the boot screen"
  sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true || fail ""

  log "Revealing IP address, hostname, OS version, etc. in the login window"
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName || fail ""

  ###############################################################################
  # Screenshots                                                                 #
  ###############################################################################
  log "Changing screenshot behaviour..."

  log "Saving screenshots to the desktop"
  defaults write com.apple.screencapture location -string "${HOME}/Desktop" || fail ""

  log "Changing screenshots to PNG format"
  defaults write com.apple.screencapture type -string "png" || fail ""

  ###############################################################################
  # Dock                                                                        #
  ###############################################################################
  log "Changing Dock settings..."

  log "Enabling autohiding"
  defaults write com.apple.dock autohide -bool true || fail ""

  log "Removing the auto-hiding Dock delay"
  defaults write com.apple.dock autohide-delay -float 0 || fail ""

  log "Removing the animation when hiding/showing the Dock"
  defaults write com.apple.dock autohide-time-modifier -float 0 || fail ""

  log "Enabling spring loading for all Dock items"
  defaults write com.apple.dock enable-spring-load-infos-on-all-items -bool true || fail ""

  log "Disabling opening apps animations from the Dock"
  defaults write com.apple.dock launchanim -bool false || fail ""

  log "Changing minimize window effect to scale"
  defaults write com.apple.dock mineffect -string "scale" || fail ""

  log "Minimizing windows into their application’s icon"
  defaults write com.apple.dock minimize-to-application -bool true || fail ""

  log "Enabling highlight hover effect for the grid view of a stack"
  defaults write com.apple.dock mouse-over-hilite-stack -bool true || fail ""

  log "Setting persistent apps"
  defaults write com.apple.dock persistent-apps -array \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Ghostty.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict><key>tile-type</key><string>file-tile</string></dict>' \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Firefox%20Developer%20Edition.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict><key>tile-type</key><string>file-tile</string></dict>' \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Obsidian.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict><key>tile-type</key><string>file-tile</string></dict>' \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Slack.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict><key>tile-type</key><string>file-tile</string></dict>' \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Mattermost.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict><key>tile-type</key><string>file-tile</string></dict>' \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Microsoft%20Teams.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict><key>tile-type</key><string>file-tile</string></dict>' \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Microsoft%20Outlook.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict><key>tile-type</key><string>file-tile</string></dict>' \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///System/Applications/System%20Settings.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict><key>tile-type</key><string>file-tile</string></dict>'

  log "Showing indicator lights for open application"
  defaults write com.apple.dock show-process-indicators -bool true || fail ""

  log "Removing recent applications"
  defaults write com.apple.dock show-recents -bool false || fail ""

  log "Making icons of hidden applications translucent"
  defaults write com.apple.dock showhidden -bool true || fail ""

  log "Setting the icon size of Dock items to 40 pixels"
  defaults write com.apple.dock tilesize -int 40 || fail ""

  ###############################################################################
  # Finder                                                                      #
  ###############################################################################
  log "Changing Finder settings..."

  log "Avoiding creating .DS_Store files on network or USB volumes"
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true || fail ""
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true || fail ""

  log "Disabling window animations and Get Info animations"
  defaults write com.apple.finder DisableAllAnimations -bool true || fail ""

  log "Changing source for search to current folder"
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" || fail ""

  log "Showing all hidden files"
  defaults write com.apple.finder "AppleShowAllFiles" -bool "true" || fail ""

  log "Disabling warning when changing file extensions"
  defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool false || fail ""

  log "Setting finder default view to list"
  defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" || fail ""

  log "Setting Downloads as the default location for new windows"
  defaults write com.apple.finder "NewWindowTarget" -string "PfLo" || fail ""
  defaults write com.apple.finder "NewWindowTargetPath" -string "file://${HOME}/Downloads/" || fail ""

  log "Showing path bar + status bar"
  defaults write com.apple.finder "ShowPathbar" -bool true || fail ""
  defaults write com.apple.finder "ShowStatusBar" -bool true || fail ""

  log "Hiding desktop drive/server icons"
  defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool false || fail ""
  defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool false || fail ""
  defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool false || fail ""
  defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool false || fail ""
  
  log "Showing full POSIX path in title bar"
  defaults write com.apple.finder "_FXShowPosixPathInTitle" -bool true || fail ""
  
  log "Keeping folders on top when sorting by name"
  defaults write com.apple.finder "_FXSortFoldersFirst" -bool true || fail ""
  
  log "Enabling Finder → Quit in menu"
  defaults write com.apple.finder "QuitMenuItem" -bool true || fail ""

  log "Expanding the File Info panes"
  # “General”, “Open with”, and “Sharing & Permissions”
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true || fail "" 

  log "Allowing text selection in Quick Look"
  defaults write com.apple.finder QLEnableTextSelection -bool true || fail ""

  log "Disabling the warning before emptying the Trash"
  defaults write com.apple.finder WarnOnEmptyTrash -bool false || fail ""

  log "Opening new window when a volume is mounted"
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true || fail ""
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true || fail ""
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true || fail ""

  log "Showing all filename extensions in Finder"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true || fail ""

  log "Setting Finder sidebar icon size to medium"
  defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1 || fail ""

  log "Showing the ~/Library folder"
  chflags nohidden ~/Library || fail ""

  log "Showing the /Volumes folder"
  sudo chflags nohidden /Volumes || fail ""

  log "Preventing opening Photos after plugging in devices"
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true || fail ""

  ###############################################################################
  # Kill affected applications                                                  #
  ###############################################################################
  log "Killing affected applications..."
  for app in "cfprefsd" \
    "Dock" \
    "Finder" \
    "SystemUIServer"; do
    killall "${app}" &>/dev/null || true
  done
}

main "$@"