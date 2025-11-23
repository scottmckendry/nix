{
  pkgs,
  config,
  lib,
  ...
}:
let
  swwwSwitcherPreferenceValues =
    let
      literalPostCommand = "ln -sf " + "$" + "{wallpaper} /tmp/current_wallpaper";
    in
    builtins.toJSON {
      colorGenTool = "none";
      gridRows = "4";
      postProduction = "no";
      postCommand = literalPostCommand;
      showImageDetails = true;
      toggleVicinaeSetting = false;
      transitionDuration = "3";
      transitionStep = "90";
      transitionType = "fade";
      wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/";
    };
in
{
  programs.vicinae = {
    enable = true;
    settings = {
      font.size = 10;
      font.normal = "JetBrainsMono Nerd Font";
      window.opacity = 1;
    };
    # TODO: Could be simplified with a flake input:
    # https://github.com/vicinaehq/vicinae/issues/598
    extensions = [
      (config.lib.vicinae.mkExtension {
        # TODO: update to awww when binary is up-to-date in nixpkgs
        # also update service swww.nix -> awww.nix
        name = "swww-switcher";
        src =
          pkgs.fetchFromGitHub {
            owner = "vicinaehq";
            repo = "extensions";
            rev = "df6ab123e4bee27efea8afc8a4ee88ecb1df39a3";
            sha256 = "sha256-8DDfVrYSZU9m4SIb0+My+iqJz/rjNc+wVpe7j6rVmJ8=";
          }
          + "/extensions/swww-switcher";
      })
    ];
  };

  home.activation.vicinaeDbConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    db="${config.home.homeDirectory}/.local/share/vicinae/vicinae.db"
    if [ ! -f "$db" ]; then
      echo "vicinae: database not found at $db; skipping custom SQL."
      exit 0
    fi

    echo "vicinae: applying custom SQL..."

    ${pkgs.sqlite}/bin/sqlite3 "$db" <<'EOF'
      -- Insert or replace swww-switcher extension settings
      INSERT INTO root_provider (id, preference_values, enabled) VALUES (
        'extension.swww-switcher', 
        '${swwwSwitcherPreferenceValues}',
        1
      ) 
      ON CONFLICT(id) DO UPDATE SET 
      preference_values = excluded.preference_values,
      enabled = excluded.enabled;
    EOF
  '';

  systemd.user.services.vicinae = {
    Unit = {
      Description = "Vicinae Server";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.vicinae}/bin/vicinae server";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
