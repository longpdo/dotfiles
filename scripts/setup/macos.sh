#!/bin/bash

# originally from https://mths.be/macos

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_ok()      { echo -e "\033[32m[OK]\033[0m $1" ; }
_error()   { echo -e "\033[31m[ERROR]\033[0m $1" ; }

###############################################################################
# Prompt user input                                                           #
###############################################################################
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

_info "These first changes request your input... \n"

read -r -p "Do you want to change your computer and host name? [y|N] " response
if [[ $response =~ (yes|y|Y) ]];then
		read -r -p "Computer: change $(sudo scutil --get ComputerName) to: " _computer_name
		sudo scutil --set ComputerName "$_computer_name" && _ok "changed computer name"
		read -r -p "Localhost: change $(sudo scutil --get LocalHostName) to: " _local_host_name
		sudo scutil --set LocalHostName "$_local_host_name" && _ok "changed host name"
else
    _ok "skipped";
fi

_info "Closing any open System Preferences panes..."
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# General                                                                     #
###############################################################################
_info "Changing General settings..."

_info "Disabling the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none" || _error ""

_info "Changing scrollbars to Always"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always" || _error ""

_info "Disabling automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true || _error ""

_info "Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false || _error ""

###############################################################################
# Dock                                                                        #
###############################################################################
_info "Changing Dock settings..."

_info "Enabling autohiding"
defaults write com.apple.dock autohide -bool true || _error ""

_info "Removing the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0 || _error ""

_info "Removing the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0 || _error ""

_info "Enabling spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-infos-on-all-items -bool true || _error ""

_info "Disabling opening apps animations from the Dock"
defaults write com.apple.dock launchanim -bool false || _error ""

_info "Changing minimize window effect to scale"
defaults write com.apple.dock mineffect -string "scale" || _error ""

_info "Minimizing windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true || _error ""

_info "Enabling highlight hover effect for the grid view of a stack"
defaults write com.apple.dock mouse-over-hilite-stack -bool true || _error ""

_info "Wiping all (default) app icons"
defaults write com.apple.dock persistent-apps -array || _error ""

_info "Showing indicator lights for open application"
defaults write com.apple.dock show-process-indicators -bool true || _error ""

_info "Removing recent applications"
defaults write com.apple.dock show-recents -bool false || _error ""

_info "Making icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true || _error ""

_info "Setting the icon size of Dock items to 40 pixels"
defaults write com.apple.dock tilesize -int 40 || _error ""

###############################################################################
# Security                                                                    #
###############################################################################
_info "Changing Security settings..."

_info "Enabling Firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on || _error ""

_info "Blocking all incoming connections"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on || _error ""

_info "Disabling remote apple events"
sudo systemsetup -setremoteappleevents off || _error ""

_info "Disabling remote login"
sudo systemsetup -setremotelogin off || _error ""

_info "Restarting automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on || _error ""

_info "Disabling wake-on LAN"
sudo systemsetup -setwakeonnetworkaccess off || _error ""

###############################################################################
# Keyboard                                                                    #
###############################################################################
_info "Changing Keyboard settings..."

_info "Enabling full keyboard access for all controls"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 || _error ""

_info "Disabling press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false || _error ""

_info "Setting fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1 || _error ""
defaults write NSGlobalDomain InitialKeyRepeat -int 12 || _error ""

_info "Disabling automatic capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false || _error ""

_info "Disabling smart dashes"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false || _error ""

_info "Disabling automatic period substitution"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false || _error ""

_info "Disabling smart quotes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false || _error ""

_info "Disabling auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false || _error ""

###############################################################################
# Mouse                                                                       #
###############################################################################
_info "Changing Mouse settings..."

_info "Setting mouse tracking speed"
defaults write NSGlobalDomain com.apple.mouse.scaling -float 3.0 || _error ""

###############################################################################
# Trackpad                                                                    #
###############################################################################
_info "Changing Trackpad settings..."

_info "Setting trackpad tracking speed"
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.0 || _error ""

_info "Enabling trackpad tap to click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true || _error ""
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 || _error ""
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 || _error ""

_info "Mapping trackpad bottom right corner to right-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2 || _error ""
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true || _error ""
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1 || _error ""
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true || _error ""

_info "Disabling 'natural' scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false || _error ""

###############################################################################
# Printer & Scanner                                                           #
###############################################################################
_info "Changing Printer & Scanner settings..."

_info "Expanding save and print panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true || _error ""
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true || _error ""
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true || _error ""
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true || _error ""

_info "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true || _error ""

###############################################################################
# Time Machine                                                                #
###############################################################################
_info "Changing Time Machine settings..."

_info "Preventing Time Machine to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true || _error ""

_info "Disable automatic Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disable && _ok ""

###############################################################################
# Booting, Login Window                                                       #
###############################################################################
_info "Disabling guest account login"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false || _error ""

_info "Showing language menu in the top right corner of the boot screen"
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true || _error ""

_info "Revealing IP address, hostname, OS version, etc. in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName || _error ""

###############################################################################
# Screenshots                                                                 #
###############################################################################
_info "Changing screenshot behaviour..."

_info "Saving screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop" || _error ""

_info "Changing screenshots to PNG format"
defaults write com.apple.screencapture type -string "png" || _error ""

###############################################################################
# Finder                                                                      #
###############################################################################
_info "Changing Finder settings..."

_info "Expanding the File Info panes"
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true || _error ""

_info "Allowing text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true || _error ""

_info "Disabling the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false || _error ""

_info "Opening new window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true || _error ""
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true || _error ""
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true || _error ""

_info "Showing all filename extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true || _error ""

_info "Setting Finder sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1 || _error ""

_info "Showing the ~/Library folder"
chflags nohidden ~/Library || _error ""

_info "Showing the /Volumes folder"
sudo chflags nohidden /Volumes || _error ""

_info "Preventing opening Photos after plugging in devices"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true || _error ""

###############################################################################
# Kill affected applications                                                  #
###############################################################################
_info "Killing affected applications..."
for app in "cfprefsd" \
	"Dock" \
	"Finder" \
	"SystemUIServer"; do
	killall "${app}" &> /dev/null
done
_ok "Done. Note that some of these changes require a logout/restart to take effect."
