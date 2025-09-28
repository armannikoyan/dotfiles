{ config, pkgs, lib, ... }:

{
  # Basic Home Manager settings
  home.username = "armannikoyan";
  home.stateVersion = "25.11";

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

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
      eval "$(starship init zsh)"

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

  home.packages = [ pkgs.starship ]; 

  home.activation.setupStarship = let
  starshipConfig = "$HOME/.config/starship.toml";
  in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  $VERBOSE_ECHO "Setting up Starship Jetpack preset"
  ${pkgs.starship}/bin/starship preset jetpack -o ${starshipConfig}

  $VERBOSE_ECHO "Disabling time and battery modules"
# Modify existing [time] section to disable it
if grep -q "^\[time\]" ${starshipConfig}; then
sed -i.tmp '/^\[time\]/,/^\[/ { /^\[time\]/ a\
disabled = true
; /^disabled = /d }' ${starshipConfig} && rm -f ${starshipConfig}.tmp
fi

# Modify existing [battery] section to disable it  
if grep -q "^\[battery\]" ${starshipConfig}; then
sed -i.tmp '/^\[battery\]/,/^\[/ { /^\[battery\]/ a\
disabled = true
; /^disabled = /d }' ${starshipConfig} && rm -f ${starshipConfig}.tmp
fi
'';

  # Home Manager itself
  programs.home-manager.enable = true;
}
