{
  description = "armannikoyan nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
    let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;
# nixpkgs.config.allowBroken = true;

# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.mkalias
        pkgs.neovim
# pkgs.valgrind
          pkgs.fzf
        ];

      homebrew =
      { enable = true;
        casks = [ "telegram"
        ];
        onActivation.cleanup = "zap";
      };

      masApps =
      {
# "[NAME]" = "[ID]"
      };

      fonts.packages =
        [ pkgs.nerd-fonts.sauce-code-pro
        ];

#       system.activationScripts.applications.text = let
# 	      env = pkgs.buildEnv {
# 		      name = "system-applications";
# 		      paths = config.environment.systemPackages;
# 		      pathsToLink = "/Applications";
# 	      };
#       in
# 	      pkgs.lib.mkForce ''
# # Set up applications.
# 	      echo "setting up /Applications..." >&2
# 	      rm -rf /Applications/Nix\ Apps
# 	      mkdir -p /Applications/Nix\ Apps
# 	      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
# 	      while read -r src; do
# 		      app_name=$(basename "$src")
# 			      echo "copying $src" >&2
# 			      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
# 			      done
# 			      '';

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
      modules =
        [ configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew =
          { enable = true;
            enableRosetta = true;
            user = "armannikoyan";
          };
        }
        ];
    };
  };
}
