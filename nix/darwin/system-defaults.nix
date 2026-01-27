{ pkgs, ... }:

{
  # https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults
  system.defaults = {
    dock = {
      autohide = true;
      minimize-to-application = true;
      mru-spaces = false;
      show-process-indicators = true;
      show-recents = false;
      showhidden = true;
      tilesize = 40;
    };

    dock.persistent-apps = [
      "/System/Library/CoreServices/Finder.app"

      # Nix apps
      "${pkgs.alacritty}/Applications/Alacritty.app"
      "${pkgs.firefox-devedition}/Applications/Firefox Developer Edition.app"
      "${pkgs.obsidian}/Applications/Obsidian.app"
      "${pkgs.slack}/Applications/Slack.app"
      "${pkgs.mattermost-desktop}/Applications/Mattermost.app"

      # Homebrew apps
      "/Applications/Microsoft Teams.app"
      "/Applications/Microsoft Outlook.app"

      "/System/Applications/System Settings.app"
    ];

    finder = {
      AppleShowAllFiles = true;                  # show dotfiles
      FXEnableExtensionChangeWarning = false;    # don't nag when changing file extensions

      FXPreferredViewStyle = "Nlsv";             # default view: list (Nlsv)
      NewWindowTarget = "PfLo";                  # new Finder windows target
      NewWindowTargetPath = "file:///Users/longdo/Downloads/";

      ShowPathbar = true;                        # show path bar
      ShowStatusBar = true;                      # show status bar
      ShowSidebar = true;                        # show sidebar
      ShowPreviewPane = false;                   # hide preview pane

      ShowExternalHardDrivesOnDesktop = false;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;

      OpenWindowForNewRemovableDisk = true;      # open window when USB/drive connects
      WarnOnEmptyTrash = false;                  # no "are you sure?" on empty trash

      _FXShowPosixPathInTitle = true;            # show full POSIX path in title bar
      _FXSortFoldersFirst = true;                # folders before files

      QuitMenuItem = true;                       # enable Finder → Quit in menu
    };

    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    screencapture = {
      disable-shadow = true;       # no window drop-shadow
      show-thumbnail = true;       # show screenshot thumbnail popup
      type = "png";                # screenshot file format
    };

    screensaver = {
      ask-for-password = true;
      ask-for-password-delay = 0;
    };

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

    # Arbitrary defaults that nix-darwin doesn't model as typed options
    CustomUserPreferences = {
      "com.apple.menuextra.clock" = {
        FlashDateSeparators = 1;
        IsAnalog = 0;
        ShowAMPM = 1;
        ShowDate = 0;
        ShowDayOfWeek = 1;
        ShowSeconds = 1;
      };

      NSGlobalDomain = {
        "com.apple.mouse.scaling" = 3;
        "com.apple.trackpad.scaling" = 2;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.trackpad.forceClick" = 1;
        "com.apple.swipescrolldirection" = 0;
      };
    };
  };
}
