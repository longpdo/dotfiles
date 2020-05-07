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

read -r -p "Do you want to overwrite /etc/hosts with the ad-blocking hosts file from someonewhocares.org [y|N] " response
if [[ $response =~ (yes|y|Y) ]];then
		_info "Backing up current /etc/hosts to /etc/hosts.backup"
		sudo cp /etc/hosts /etc/hosts.backup && _ok "backed up hosts"
		_info "Overwriting /etc/hosts"
		sudo cp ./config/hosts /etc/hosts && _ok "overwrote hosts"
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

_info "Setting Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true || _error ""

_info "Disabling the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false || _error ""

_info "Setting highlight color to green"
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600" || _error ""

_info "Enabling dark mode"
defaults write NSGlobalDomain AppleInterfaceStyle Dark || _error ""

_info "Changing scrollbars to Always"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always" || _error ""

_info "Disabling automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true || _error ""

_info "Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false || _error ""

_info "Increasing window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001 || _error ""

_info "Disabling SSD hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0 || _error ""

_info "Removing duplicates in the 'Open With' menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user || _error ""

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

_info "Setting dock orientation to bottom"
defaults read com.apple.dock orientation bottom || _error ""

_info "Setting the icon size of Dock items to 40 pixels"
defaults write com.apple.dock tilesize -int 40 || _error ""

_info "Disabling the focus ring animation"
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false || _error ""

###############################################################################
# Mission Control                                                             #
###############################################################################
_info "Changing Mission Control settings..."

_info "Disabling Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true || _error ""

_info "Removing Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true || _error ""

_info "Speeding up Mission Control animation"
defaults write com.apple.dock expose-animation-duration -float 0.1 || _error ""

_info "Disabling grouping windows by application in Mission Control"
defaults write com.apple.dock expose-group-by-app -bool false || _error ""

_info "Disabling rearranging of Spaces based on recent usage"
defaults write com.apple.dock mru-spaces -bool false || _error ""

###############################################################################
# Language & Region                                                           #
###############################################################################
_info "Changing Language & Region settings..."

_info "Setting timezone to Europe/Berlin"
sudo systemsetup -settimezone "Europe/Berlin" > /dev/null || _error ""

###############################################################################
# Security                                                                    #
###############################################################################
_info "Changing Security settings..."

_info "Enabling Firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on || _error ""

_info "Blocking all incoming connections"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on || _error ""

_info "Whitelisting java from the Firewall"
_currentJavaHome=$(/usr/libexec/java_home)
_currentJavaHome="$_currentJavaHome/bin/java"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add "$_currentJavaHome" || _error ""

_info "Disabling remote apple events"
sudo systemsetup -setremoteappleevents off || _error ""

_info "Disabling remote login"
sudo systemsetup -setremotelogin off || _error ""

_info "Restarting automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on || _error ""

_info "Disabling wake-on modem"
sudo systemsetup -setwakeonmodem off || _error ""

_info "Disabling wake-on LAN"
sudo systemsetup -setwakeonnetworkaccess off || _error ""

###############################################################################
# Monitors                                                                    #
###############################################################################
_info "Changing Monitors settings..."

_info "Enabling subpixel font rendering on non-Apple LCDs"
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1 || _error ""

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

# needs Sytem Integrity Protection disabled to work
_info "Stopping iTunes from responding to the keyboard media keys"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null || _error ""

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

_info "Disabling the Launchpad gesture (pinch with thumb and three fingers)"
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0 || _error ""

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
# Audio                                                                       #
###############################################################################
_info "Changing Audio settings..."

_info "Increasing sound quality for Bluetooth headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40 || _error ""

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

_info "Booting always in verbose mode (not MacOS GUI mode)"
sudo nvram boot-args="-v" || _error ""

_info "Disabling the sound effects on boot"
sudo nvram SystemAudioVolume=" " || _error ""

###############################################################################
# Menu Bar                                                                    #
###############################################################################
_info "Organizing the menu bar..."

_info "Hiding Siri menu bar icon and deactivating"
defaults write com.apple.Siri StatusMenuVisible -bool false || _error ""
defaults write com.apple.Siri UserHasDeclinedEnable -bool true || _error ""
defaults write com.apple.assistant.support 'Assistant Enabled' 0 || _error ""

_info "Displaying only Airport and Clock in menu bar"
defaults delete com.apple.systemuiserver "NSStatusItem Preferred Position com.apple.menuextra.battery" || _error ""
defaults delete com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" || _error ""
defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" || _error ""

###############################################################################
# Screenshots                                                                 #
###############################################################################
_info "Changing screenshot behaviour..."

_info "Saving screenshots to the desktop"
defaults write com.applse.screencapture location -string "${HOME}/Desktop" || _error ""

_info "Changing screenshots to PNG format"
defaults write com.apple.screencapture type -string "png" || _error ""

_info "Disabling shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true || _error ""

###############################################################################
# Finder                                                                      #
###############################################################################
_info "Changing Finder settings..."

_info "Avoiding creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true || _error ""
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true || _error ""

_info "Displaying full POSIX path as Finders window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true || _error ""

_info "Keeping folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true || _error ""

_info "Showing all hidden files"
defaults write com.apple.finder AppleShowAllFiles true || _error ""

_info "Disabling window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true || _error ""

_info "Changing source for search to current folder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" || _error ""

_info "Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false || _error ""

_info "Expanding the File Info panes"
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true || _error ""

_info "Changing to list view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" || _error ""

_info "Setting Downloads as the default location for new windows"
defaults write com.apple.finder NewWindowTarget -string "PfLo" || _error ""
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/" || _error ""

_info "Allowing text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true || _error ""

_info "Allowing Finder quitting via ⌘ + Q"
defaults write com.apple.finder QuitMenuItem -bool true || _error ""

_info "Hiding all hard drive and server icons from desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false || _error ""
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false || _error ""
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false || _error ""
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false || _error ""

_info "Showing Finder path bar"
defaults write com.apple.finder ShowPathbar -bool true || _error ""

_info "Showing Finder status bar"
defaults write com.apple.finder ShowStatusBar -bool true || _error ""

_info "Disabling the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false || _error ""

_info "Disabling disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true || _error ""
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true || _error ""
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true || _error ""

_info "Opening new window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true || _error ""
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true || _error ""
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true || _error ""

_info "Enabling AirDrop over Ethernet"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true || _error ""

_info "Disabling spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool false || _error ""

_info "Showing all filename extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true || _error ""

_info "Setting Finder sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1 || _error ""

_info "Showing the ~/Library folder"
chflags nohidden ~/Library || _error ""

_info "Showing the /Volumes folder"
sudo chflags nohidden /Volumes || _error ""

###############################################################################
# Activity Monitor, Address Book, Disk Utility, TextEdit                      #
###############################################################################
_info "Changing Apple Apps settings..."

_info "Visualizing CPU usage in Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5 || _error ""

_info "Showing the main window after launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true || _error ""

_info "Showing all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0 || _error ""

_info "Sorting results by CPU usage in Activity Monitor"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage" || _error ""
defaults write com.apple.ActivityMonitor SortDirection -int 0 || _error ""

_info "Enabling the debug menu in Adress Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true || _error ""

_info "Enabling the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true || _error ""
defaults write com.apple.DiskUtility advanced-image-options -bool true || _error ""

_info "Using plain text mode for new documents in TextEdit"
defaults write com.apple.TextEdit RichText -int 0 || _error ""

_info "Changing to UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4 || _error ""
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4 || _error ""

_info "Preventing opening Photos after plugging in devices"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true || _error ""

###############################################################################
# Terminal                                                                    #
###############################################################################
_info "Changing Terminal settings..."

_info "Allowing only UTF-8 in Terminal"
defaults write com.apple.terminal StringEncodings -array 4 || _error ""

_info "Enabling Secure Keyboard Entry in Terminal"
defaults write com.apple.terminal SecureKeyboardEntry -bool true || _error ""

_info "Disabling line marks in Terminal"
defaults write com.apple.Terminal ShowLineMarks -int 0 || _error ""

###############################################################################
# Safari & WebKit                                                             #
###############################################################################
_info "Changing Safari settings..."

_info "Disabling AutoFill in Safari"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false || _error ""
defaults write com.apple.Safari AutoFillPasswords -bool false || _error ""
defaults write com.apple.Safari AutoFillCreditCardData -bool false || _error ""
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false || _error ""

_info "Preventing opening files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false || _error ""

_info "Mapping Backspace key to go to the previous page in Safari"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true || _error ""

_info "Disabling thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2 || _error ""

_info "Making search default in Safari to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false || _error ""

_info "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true || _error ""
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true || _error ""
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true || _error ""

_info "Enabling debug menu in Safari"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true || _error ""

_info "Updating Safari extensions automatically"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true || _error ""

_info "Removing useless icons from Safari bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()" || _error ""

_info "Enabling Do Not Track in Safari"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true || _error ""

_info "Hiding bookmarks bar in Safari"
defaults write com.apple.Safari ShowFavoritesBar -bool false || _error ""

_info "Showing the full URL in the Safari address bar"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true || _error ""

_info "Hiding sidebar in Safari Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false || _error ""

_info "Diabling search queries to Apple in Safari"
defaults write com.apple.Safari UniversalSearchEnabled -bool false || _error ""
defaults write com.apple.Safari SuppressSearchSuggestions -bool true || _error ""

_info "Warning about fraudulent websites in Safari"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true || _error ""

_info "Disabling auto-correct in Safari"
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false || _error ""

_info "Enabling continuous spellchecking in Safari"
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true || _error ""

_info "Adding context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true || _error ""

_info "Disabling Java in Safari"
defaults write com.apple.Safari WebKitJavaEnabled -bool false || _error ""
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false || _error ""

_info "Blocking pop-up windows in Safari"
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false || _error ""
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false || _error ""

_info "Disabling auto-playing video in Safari"
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false || _error ""
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false || _error ""
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false || _error ""
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false || _error ""

_info "Disabling plug-ins in Safari"
defaults write com.apple.Safari WebKitPluginsEnabled -bool false || _error ""
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false || _error ""

###############################################################################
# Mail                                                                        #
###############################################################################
_info "Changing Mail settings..."

_info "Copying email addresses without name"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false || _error ""

_info "Disabling inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true || _error ""

_info "Disabling send and reply animations"
defaults write com.apple.mail DisableReplyAnimations -bool true || _error ""
defaults write com.apple.mail DisableSendAnimations -bool true || _error ""

_info "Displaying emails in threaded mode (oldest at the top)"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes" || _error ""
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes" || _error ""
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date" || _error ""

_info "Adding keyboard shortcut ⌘ + Enter to send an email"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9" || _error ""

_info "Disabling automatic spell checking in Mail"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled" || _error ""
_ok

###############################################################################
# Mac App Store                                                               #
###############################################################################
_info "Changing Mac App Store settings..."

_info "Enabling Debug Menu in App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true || _error ""

_info "Enabling the WebKit Developer Tools in App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true || _error ""

_info "Turning on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true || _error ""

_info "Allowing to reboot machine on macOS updates"
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true || _error ""

_info "Enabling the automatic update check in App Store"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true || _error ""

_info "Downloading newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1 || _error ""

_info "Downloading apps purchased on other Macs automatically"
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1 || _error ""

_info "Installing System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1 || _error ""

_info "Checking for software updates daily"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1 || _error ""

###############################################################################
# Kill affected applications                                                  #
###############################################################################
_info "Killing affected applications..."
for app in "Activity Monitor" \
	"cfprefsd" \
	"Dock" \
	"Finder" \
	"Mail" \
	"Photos" \
	"Safari" \
	"Spotlight" \
	"SystemUIServer"; do
	killall "${app}" &> /dev/null
done
_ok "Done. Note that some of these changes require a logout/restart to take effect."
