{ config, pkgs, lib, ... }:

{
  # Basic Home Manager settings
  home.username = "armannikoyan";
  home.stateVersion = "24.05";

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  # Packages
  home.packages = [
    # Add starship to packages if you want HM to manage installation
    # pkgs.starship
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 10000;
      share = true;
      extended = true;
    };

    shellAliases = {
      ll = "ls -l";
    };

    initContent = ''
      # Vi mode settings
      set -o vi
      bindkey -v '^?' backward-delete-char

      # Dart FVM setup
      if [ -d "$HOME/fvm/versions" ]; then
        for dir in $HOME/fvm/versions/*/bin; do
          [ -d "$dir" ] && PATH="${PATH:+$PATH:}$dir"
        done
      fi

      # Terminal-specific settings
      if [[ $TERM_PROGRAM == "Apple_Terminal" ]]; then
        update_terminal_cwd() {
          local ENCODED_PWD="$(echo $PWD | sed 's/ /%20/g')"
          local PWD_URL="file://$HOSTNAME$ENCODED_PWD"
          printf '\e]7;%s\a' "$PWD_URL"
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd update_terminal_cwd
        update_terminal_cwd
      fi
    '';
  };

  # Starship configuration
  # programs.starship = {
  #   enable = true;
    # Add custom starship configuration if needed
    # settings = { 
    #   add_newline = false;
    # };
  # };

  # Home Manager itself
  programs.home-manager.enable = true;
}
