{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  awwwSwitcherPreferenceValues = builtins.toJSON {
    colorGenTool = "none";
    gridRows = "4";
    postProduction = "no";
    postCommand = "ln -sf $" + "{wallpaper} /tmp/current_wallpaper";
    showImageDetails = true;
    toggleVicinaeSetting = false;
    transitionDuration = "3";
    transitionStep = "90";
    transitionType = "fade";
    wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/";
  };
  clipboardHistoryPreferenceValues = builtins.toJSON {
    defaultAction = "copy";
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
    extensions = [
      (config.lib.vicinae.mkExtension {
        name = "awww-switcher";
        src = "${inputs.vicinae-extensions}/extensions/awww-switcher";
      })
      (config.lib.vicinae.mkExtension {
        name = "nix";
        src = "${inputs.vicinae-extensions}/extensions/nix";
      })
    ];
  };

  home.activation.vicinaeDbConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    db=${config.home.homeDirectory}/.local/share/vicinae/vicinae.db
    test $db || return 0
    echo "vicinae: applying custom SQL..."

    ${pkgs.sqlite}/bin/sqlite3 "$db" <<'EOF'
      -- Insert or replace awww-switcher extension settings
      INSERT INTO root_provider (id, preference_values, enabled) VALUES (
        'extension.awww-switcher', 
        '${awwwSwitcherPreferenceValues}',
        1
      ) 
      ON CONFLICT(id) DO UPDATE SET 
      preference_values = excluded.preference_values,
      enabled = excluded.enabled;

      -- Insert or replace clipboard-history extension settings
      INSERT INTO root_provider_item (id, provider_id, preference_values, enabled) VALUES(
        'extension.clipboard.history',
        'extension.clipboard',
        '${clipboardHistoryPreferenceValues}',
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
