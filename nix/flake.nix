{
  description = "Nix Configuration for MacOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = { self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    # ------------------------------------------
    hostname = "mac";
    user = "longdo";
    platform = "aarch64-darwin";
    # ------------------------------------------

    configuration = { pkgs, ... }: {
      imports = [
        ./darwin/apps.nix
        ./darwin/system-defaults.nix
      ];

      system.primaryUser = user;

      nix.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # Allow non open source apps to be installed.
      nixpkgs.config.allowUnfree = true;
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = platform;
    };
  in
  {
    # Build darwin flake using: $ darwin-rebuild build --flake .#mac
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      system = platform;
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # Apple Silicon Only
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = user;
            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
  };
}
