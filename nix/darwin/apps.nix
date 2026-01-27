{ pkgs, ... }:

{
  # Nix packages: https://search.nixos.org/packages?channel=unstable&
  environment.systemPackages = with pkgs; [

    # --- CLI tools ---
    bat                       # better cat
    eza                       # better ls
    fastfetch                 # better neofetch
    fd                        # better find
    ripgrep                   # better grep
    tealdeer                  # better tldr
    scc                       # better loc
    zoxide                    # better cd

    # --- TUI tools ---
    fzf                       # fuzzy finder
    navi                      # interactive cheatsheet tool
    neovim                    # better vim

    # --- GUI apps ---
    bitwarden-desktop         # password manager
    bruno                     # API client 
    firefox-devedition        # browser
    ghostty                   # terminal
    jetbrains.idea-ultimate   # IDE
    iina                      # media player
    losslesscut-bin           # video editing
    mattermost-desktop        # chat client
    obs-studio                # video recording
    obsidian                  # notes
    slack                     # chat client
    vscode                    # text editor

    # --- Dev Packages ---
    git                       # VCS
    jq                        # JSON processor
    kubectl                   # Kubernetes CLI
    maven                     # Java build tool
    nodejs                    # JavaScript runtime
    pgadmin4-desktopmode      # Postgres client
    pipx                      # isolated python apps
    podman                    # docker
    podman-compose            # docker-compose
    temurin-bin-21            # OpenJDK 21


    # -- Desktop Enviroment apps ---
    # aerospace               # tiling window manager
    raycast                   # better spotlight
    # sketchybar              # better status bar

  ];

  # Fonts
  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Homebrew apps (casks, brews, MAS)
  homebrew = {
    enable = true;

    casks = [
      "microsoft-word"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-outlook"
      "microsoft-teams"
    ];

    onActivation.cleanup = "zap";
  };
}
