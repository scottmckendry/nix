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
      theme.name = "cyberdream";
      font.size = 10;
      font.normal = "JetBrainsMono Nerd Font";
      window.opacity = 1;
    };
    themes.cyberdream = {
      meta = {
        name = "Cyberdream";
        description = "Cyberdream theme for vicinae";
        variant = "dark";
        inherits = "vicinae-dark";
      };
      colors.core = {
        accent = "#5ea1ff";
        accent_foreground = "#ffffff";
        background = "#16181a";
        foreground = "#ffffff";
        secondary_background = "#1e2124";
        border = "#3c4048";
      };
      colors.accents = {
        blue = "#5ea1ff";
        green = "#5eff6c";
        magenta = "#ff5ea0";
        orange = "#ffbd5e";
        red = "#ff6e5e";
        yellow = "#f1ff5e";
        cyan = "#5ef1ff";
        purple = "#bd5eff";
      };
      colors.text = {
        default = "#ffffff";
        muted = "#7b8496";
        danger = "#ff6e5e";
        success = "#5eff6c";
        placeholder = "#e8e6e1";
        selection = {
          background = "#5ea1ff";
          foreground = "#ffffff";
        };
        links = {
          default = "#5ea1ff";
          visited = "#ff5ea0";
        };
      };
      colors.input = {
        border = "#7b8496";
        border_focus = "#5ea1ff";
        border_error = "#ff6e5e";
      };
      colors.button.primary = {
        background = "#3c4048";
        foreground = "#ffffff";
        hover = {
          background = "#5ea1ff";
        };
        focus = {
          outline = "#5ea1ff";
        };
      };
      colors.list.item = {
        hover = {
          background = "#3c4048";
          foreground = "#ffffff";
        };
        selection = {
          background = "#3c4048";
          foreground = "#ffffff";
          secondary_background = "#3c4048";
          secondary_foreground = "#7b8496";
        };
      };
      colors.grid.item = {
        background = "#3c4048";
        hover = {
          outline = "#ffffff";
        };
        selection = {
          outline = "#ffffff";
        };
      };
      colors.scrollbars = {
        background = "#7b8496";
      };
      colors.loading = {
        bar = "#5ea1ff";
        spinner = "#5ea1ff";
      };
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
