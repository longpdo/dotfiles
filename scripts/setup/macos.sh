#!/usr/bin/env bash

# originally from https://mths.be/macos

# Include library helper for colorized echo
source ./_helpers/colorized-echo.sh
source ./_helpers/installers.sh

###############################################################################
# Prompt user input                                                           #
###############################################################################
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing sudo time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "These first changes request your input... \n"

read -r -p "Do you want to change your computer and host name? [y|N] " response
if [[ $response =~ (yes|y|Y) ]];then
		read -r -p "Computer: change $(sudo scutil --get ComputerName) to: " computerName
		sudo scutil --set ComputerName $computerName
		ok
		read -r -p "Localhost: change $(sudo scutil --get LocalHostName) to: " localHostName
		sudo scutil --set LocalHostName $localHostName
		ok
else
    ok "skipped";
fi

read -r -p "Do you want to overwrite /etc/hosts with the ad-blocking hosts file from someonewhocares.org [y|N] " response
if [[ $response =~ (yes|y|Y) ]];then
		running "Backing up current /etc/hosts to /etc/hosts.backup"
		sudo cp /etc/hosts /etc/hosts.backup; ok
		running "Overwriting /etc/hosts"
		sudo cp ./config/hosts /etc/hosts; ok
		ok
else
    ok "skipped";
fi

action "Closing any open System Preferences panes..."
osascript -e 'tell application "System Preferences" to quit'
ok

###############################################################################
# General                                                                     #
###############################################################################
action "Changing General settings..."

running "Disabling the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"; ok

running "Setting Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true; ok

running "Disabling the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false; ok

running "Setting highlight color to green"
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"; ok

running "Enabling dark mode"
defaults write NSGlobalDomain AppleInterfaceStyle Dark; ok

running "Changing scrollbars to Always"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"; ok

running "Disabling automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true; ok

running "Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false; ok

running "Increasing window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001; ok

running "Disabling SSD hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0; ok

running "Removing duplicates in the “Open With” menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user; ok

###############################################################################
# Dock                                                                        #
###############################################################################
action "Changing Dock settings..."

running "Enabling autohiding"
defaults write com.apple.dock autohide -bool true; ok

running "Removing the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0; ok

running "Removing the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0; ok

running "Enabling spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true; ok

running "Disabling opening apps animations from the Dock"
defaults write com.apple.dock launchanim -bool false; ok

running "Changing minimize window effect to scale"
defaults write com.apple.dock mineffect -string "scale"; ok

running "Minimizing windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true; ok

running "Enabling highlight hover effect for the grid view of a stack"
defaults write com.apple.dock mouse-over-hilite-stack -bool true; ok

running "Wiping all (default) app icons"
defaults write com.apple.dock persistent-apps -array; ok

running "Showing indicator lights for open application"
defaults write com.apple.dock show-process-indicators -bool true; ok

running "Removing recent applications"
defaults write com.apple.dock show-recents -bool false; ok

running "Making icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true; ok

running "Setting dock orientation to bottom"
defaults read com.apple.dock orientation bottom

running "Setting the icon size of Dock items to 40 pixels"
defaults write com.apple.dock tilesize -int 40; ok

running "Disabling the focus ring animation"
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false; ok

###############################################################################
# Mission Control                                                             #
###############################################################################
action "Changing Mission Control settings..."

running "Disabling Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true; ok

running "Removing Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true; ok

running "Speeding up Mission Control animation"
defaults write com.apple.dock expose-animation-duration -float 0.1; ok

running "Disabling grouping windows by application in Mission Control"
defaults write com.apple.dock expose-group-by-app -bool false; ok

running "Disabling rearranging of Spaces based on recent usage"
defaults write com.apple.dock mru-spaces -bool false; ok

###############################################################################
# Language & Region                                                           #
###############################################################################
action "Changing Language & Region settings..."

running "Setting timezone to Europe/Berlin"
sudo systemsetup -settimezone "Europe/Berlin" > /dev/null; ok

###############################################################################
# Security                                                                    #
###############################################################################
action "Changing Security settings..."

running "Enabling Firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on; ok

running "Blocking all incoming connections"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on; ok

running "Whitelisting java from the Firewall"
currentJavaHome=$(/usr/libexec/java_home)
currentJavaHome=$currentJavaHome"/bin/java"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add $currentJavaHome
ok

running "Disabling remote apple events"
sudo systemsetup -setremoteappleevents off; ok

running "Disabling remote login"
sudo systemsetup -setremotelogin off; ok

running "Restarting automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on; ok

running "Disabling wake-on modem"
sudo systemsetup -setwakeonmodem off; ok

running "Disabling wake-on LAN"
sudo systemsetup -setwakeonnetworkaccess off; ok

###############################################################################
# Monitors                                                                    #
###############################################################################
action "Changing Monitors settings..."

running "Activating night shift"
plistLoc="/private/var/root/Library/Preferences/com.apple.CoreBrightness.plist"
currentUserUID=$(dscl . -read /Users/$(whoami)/ GeneratedUID) # Get the GeneratedUID for the current user
currentUserUID=$(echo $currentUserUID | cut -d' ' -f2) # Remove the "GeneratedUID: " part
currentUserUID="CBUser-"$currentUserUID # Append the prefix
sudo /usr/libexec/PlistBuddy -c "Set :$currentUserUID:CBBlueReductionStatus:BlueReductionMode 1" $plistLoc
ok

running "Enabling subpixel font rendering on non-Apple LCDs"
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1; ok

###############################################################################
# Keyboard                                                                    #
###############################################################################
action "Changing Keyboard settings..."

running "Enabling full keyboard access for all controls"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3; ok

running "Disabling press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false; ok

running "Setting fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 12
ok

running "Disabling automatic capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false; ok

running "Disabling smart dashes"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false; ok

running "Disabling automatic period substitution"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false; ok

running "Disabling smart quotes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false; ok

running "Disabling auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false; ok

# needs Sytem Integrity Protection disabled to work
running "Stopping iTunes from responding to the keyboard media keys"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null; ok

###############################################################################
# Mouse                                                                       #
###############################################################################
action "Changing Mouse settings..."

running "Setting mouse tracking speed"
defaults write NSGlobalDomain com.apple.mouse.scaling -float 3.0; ok

###############################################################################
# Trackpad                                                                    #
###############################################################################
action "Changing Trackpad settings..."

running "Setting trackpad tracking speed"
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.0; ok

running "Enabling trackpad tap to click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
ok

running "Mapping trackpad bottom right corner to right-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
ok

running "Disabling “natural” scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false; ok

running "Disabling the Launchpad gesture (pinch with thumb and three fingers)"
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0; ok

###############################################################################
# Printer & Scanner                                                           #
###############################################################################
action "Changing Printer & Scanner settings..."

running "Expanding save and print panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
ok

running "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true; ok

###############################################################################
# Audio                                                                       #
###############################################################################
action "Changing Audio settings..."

running "Increasing sound quality for Bluetooth headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40; ok

###############################################################################
# Time Machine                                                                #
###############################################################################
action "Changing Time Machine settings..."

running "Preventing Time Machine to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true; ok

running "Disable automatic Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disable

###############################################################################
# Booting, Login Window                                                       #
###############################################################################
running "Disabling guest account login"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false; ok

running "Showing language menu in the top right corner of the boot screen"
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true; ok

running "Revealing IP address, hostname, OS version, etc. in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName; ok

running "Booting always in verbose mode (not MacOS GUI mode)"
sudo nvram boot-args="-v"; ok

running "Disabling the sound effects on boot"
sudo nvram SystemAudioVolume=" "; ok

###############################################################################
# Menu Bar                                                                    #
###############################################################################
action "Organizing the menu bar..."

running "Hiding Siri menu bar icon and deactivating"
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Siri UserHasDeclinedEnable -bool true
defaults write com.apple.assistant.support 'Assistant Enabled' 0
ok

running "Displaying only Airport and Clock in menu bar"
defaults delete com.apple.systemuiserver "NSStatusItem Preferred Position com.apple.menuextra.battery"
defaults delete com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery"
defaults write com.apple.systemuiserver menuExtras -array \
    "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
    "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
ok

# needs Sytem Integrity Protection disabled to work
running "Removing Spotlight icon from menu bar"
currentDir=$(pwd)
cd /System/Library/CoreServices/Spotlight.app/Contents/MacOS
sudo cp Spotlight Spotlight.bak
sudo perl -pi -e 's|(\x00\x00\x00\x00\x00\x00\x47\x40\x00\x00\x00\x00\x00\x00)\x42\x40(\x00\x00\x80\x3f\x00\x00\x70\x42)|$1\x00\x00$2|sg' Spotlight
sudo codesign -f -s - Spotlight
cd $currentDir
ok

###############################################################################
# Screenshots                                                                 #
###############################################################################
action "Changing screenshot behaviour..."

running "Saving screenshots to the desktop"
defaults write com.applse.screencapture location -string "${HOME}/Desktop"; ok

running "Changing screenshots to PNG format"
defaults write com.apple.screencapture type -string "png"; ok

running "Disabling shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true; ok

###############################################################################
# Finder                                                                      #
###############################################################################
action "Changing Finder settings..."

running "Avoiding creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
ok

running "Displaying full POSIX path as Finders window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true; ok

running "Keeping folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true; ok

running "Showing all hidden files"
defaults write com.apple.finder AppleShowAllFiles true; ok

running "Disabling window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true; ok

running "Changing source for search to current folder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"; ok

running "Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false; ok

running "Expanding the File Info panes"
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true
ok

running "Changing to list view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"; ok

running "Setting Downloads as the default location for new windows"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"
ok

running "Allowing text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true; ok

running "Allowing Finder quitting via ⌘ + Q"
defaults write com.apple.finder QuitMenuItem -bool true; ok

running "Hiding all hard drive and server icons from desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
ok

running "Showing Finder path bar"
defaults write com.apple.finder ShowPathbar -bool true; ok

running "Showing Finder status bar"
defaults write com.apple.finder ShowStatusBar -bool true; ok

running "Disabling the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false; ok

running "Disabling disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
ok

running "Opening new window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
ok

running "Enabling AirDrop over Ethernet"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true; ok

running "Disabling spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool false; ok

running "Showing all filename extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true; ok

running "Setting Finder sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1; ok

running "Showing the ~/Library folder"
chflags nohidden ~/Library; ok

running "Showing the /Volumes folder"
sudo chflags nohidden /Volumes; ok

###############################################################################
# Activity Monitor, Address Book, Disk Utility, TextEdit                      #
###############################################################################
action "Changing Apple Apps settings..."

running "Visualizing CPU usage in Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5; ok

running "Showing the main window after launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true; ok

running "Showing all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0; ok

running "Sorting results by CPU usage in Activity Monitor"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
ok

running "Enabling the debug menu in Adress Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true; ok

running "Enabling the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true
ok

running "Using plain text mode for new documents in TextEdit"
defaults write com.apple.TextEdit RichText -int 0; ok

running "Changing to UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
ok

running "Preventing opening Photos after plugging in devices"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true; ok

###############################################################################
# Terminal                                                                    #
###############################################################################
action "Changing Terminal settings..."

running "Allowing only UTF-8 in Terminal"
defaults write com.apple.terminal StringEncodings -array 4; ok

running "Enabling Secure Keyboard Entry in Terminal"
defaults write com.apple.terminal SecureKeyboardEntry -bool true; ok

running "Disabling line marks in Terminal"
defaults write com.apple.Terminal ShowLineMarks -int 0; ok

###############################################################################
# Safari & WebKit                                                             #
###############################################################################
action "Changing Safari settings..."

running "Disabling AutoFill in Safari"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
ok

running "Preventing opening files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false; ok

running "Mapping Backspace key to go to the previous page in Safari"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true; ok

running "Disabling thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2; ok

running "Making search default in Safari to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false; ok

running "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
ok

running "Enabling debug menu in Safari"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true; ok

running "Updating Safari extensions automatically"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true; ok

running "Removing useless icons from Safari bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"; ok

running "Enabling Do Not Track in Safari"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true; ok

running "Hiding bookmarks bar in Safari"
defaults write com.apple.Safari ShowFavoritesBar -bool false; ok

running "Showing the full URL in the Safari address bar"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true; ok

running "Hiding sidebar in Safari Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false; ok

running "Diabling search queries to Apple in Safari"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
ok

running "Warning about fraudulent websites in Safari"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true; ok

running "Disabling auto-correct in Safari"
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false; ok

running "Enabling continuous spellchecking in Safari"
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true; ok

running "Adding context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true; ok

running "Disabling Java in Safari"
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
ok

running "Blocking pop-up windows in Safari"
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
ok

running "Disabling auto-playing video in Safari"
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
ok

running "Disabling plug-ins in Safari"
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false
ok

###############################################################################
# Mail                                                                        #
###############################################################################
action "Changing Mail settings..."

running "Copying email addresses without name"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false; ok

running "Disabling inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true; ok
ok

running "Disabling send and reply animations"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true
ok

running "Displaying emails in threaded mode (oldest at the top)"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"
ok

running "Adding keyboard shortcut ⌘ + Enter to send an email"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"; ok

running "Disabling automatic spell checking in Mail"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"; ok
ok

###############################################################################
# Mac App Store                                                               #
###############################################################################
action "Changing Mac App Store settings..."

running "Enabling Debug Menu in App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true; ok

running "Enabling the WebKit Developer Tools in App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true; ok

running "Turning on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true; ok

running "Allowing to reboot machine on macOS updates"
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true; ok

running "Enabling the automatic update check in App Store"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true; ok

running "Downloading newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1; ok

running "Downloading apps purchased on other Macs automatically"
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1; ok

running "Installing System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1; ok

running "Checking for software updates daily"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1; ok

###############################################################################
# Kill affected applications                                                  #
###############################################################################
bot "Killing affected applications..."
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
ok "Done. Note that some of these changes require a logout/restart to take effect."
