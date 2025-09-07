{
  description = "armannikoyan nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
    let
      configuration = { config, pkgs, ... }: {
        nixpkgs.config.allowUnfree = true;
        # nixpkgs.config.allowBroken = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [
          pkgs.mkalias
          pkgs.rustup
          pkgs.nodejs_24
          pkgs.neovim
          # pkgs.valgrind
          # neovim config deps
          pkgs.lua5_1
          pkgs.lua51Packages.luarocks_bootstrap
          pkgs.lua51Packages.jsregexp
          pkgs.wget
          pkgs.php84Packages.cyclonedx-php-composer
          pkgs.go
          pkgs.php
          pkgs.julia_19-bin
          pkgs.tree-sitter
          pkgs.ripgrep
          # end of neovim config deps
          pkgs.zulu
          pkgs.fvm
          pkgs.cocoapods
          pkgs.gcc
        ];

        # Define user and home directory
        users.users.armannikoyan = {
          home = "/Users/armannikoyan";
          shell = pkgs.zsh;
        };

        homebrew = {
          enable = true;
          brews = [
            "mas"
          ];
          casks = [
            "steam"
            "container"
            "spotify"
          ];
          masApps = {
            "Telegram" = 747648890;
          };
          onActivation.cleanup = "zap";
        };

        fonts.packages = [
          pkgs.nerd-fonts.sauce-code-pro
        ];

        system.activationScripts.applications.text = let
          env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = "/Applications";
          };
        in
          pkgs.lib.mkForce ''
            # Set up applications.
            echo "setting up /Applications..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read -r src; do
              app_name=$(basename "$src")
              echo "copying $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/$app_name"
            done
          '';

        system.primaryUser = "armannikoyan";

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."armannikoyan" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "armannikoyan";
            };
          }

          home-manager.darwinModules.home-manager
          {
            # Put HM-managed packages into the user profile
            home-manager.useUserPackages = true;
            # Optional: keep backups of files HM overwrites (e.g., .zshrc)
            home-manager.backupFileExtension = "hm-bak";

            # Point HM to your user config below
            home-manager.users."armannikoyan" = import ./home/armannikoyan/home.nix;
          }
        ];
      };
    };
}
