{ pkgs, ... }:

{
  # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults
  system.defaults = {
    dock.persistent-apps = [
      "/System/Library/CoreServices/Finder.app"

      "/Applications/Ghostty.app"
      "/Applications/Firefox Developer Edition.app"
      "/Applications/Obsidian.app"
      "/Applications/Slack.app"
      "/Applications/Mattermost.app"
      "/Applications/Microsoft Teams.app"
      "/Applications/Microsoft Outlook.app"

      "/System/Applications/System Settings.app"
    ];

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;     # enable key repeat instead of press-hold popup
      AppleShowScrollBars = "Always";       # show scroll bars always
      InitialKeyRepeat = 15;                # delay before repeat starts
      KeyRepeat = 2;                        # extremely fast repeat
      NSNavPanelExpandedStateForSaveMode = true;   # expanded save dialog
      NSNavPanelExpandedStateForSaveMode2 = true;  # expanded open dialog
    };
  };
}
