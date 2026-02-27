{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.vicinae = {
    enable = true;
    settings = {
      pop_to_root_on_close = true;
      font = {
        normal = {
          family = "JetBrains Mono Nerd Font";
          size = 10;
        };
      };
      launcher_window = {
        opacity = 0.875;
      };
      theme = {
        dark = {
          name = "cyberdream";
        };
      };
      providers = {
        "@sovereign/awww-switcher" = {
          preferences = {
            postCommand = "ln -sf \${wallpaper} /tmp/current_wallpaper";
            transitionFPS = "144";
            transitionType = "fade";
            wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/";
          };
        };
        clipboard = {
          entrypoints = {
            history = {
              preferences = {
                defaultAction = "copy";
              };
            };
          };
        };
      };
    };
    themes.cyberdream = builtins.fromTOML (
      builtins.readFile "${inputs.cyberdream.extras.vicinae}/cyberdream.toml"
    );
    extensions = [
      (config.lib.vicinae.mkExtension {
        name = "awww-switcher";
        src = "${inputs.vicinae-extensions}/extensions/awww-switcher";
      })
      (config.lib.vicinae.mkExtension {
        name = "html-symbol-finder";
        src = "${inputs.vicinae-extensions}/extensions/html-symbol-finder";
      })
      (config.lib.vicinae.mkExtension {
        name = "nix";
        src = "${inputs.vicinae-extensions}/extensions/nix";
      })
      (config.lib.vicinae.mkExtension {
        name = "spongebob-text-transformer";
        src = "${inputs.vicinae-extensions}/extensions/spongebob-text-transformer";
      })
    ];
  };

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
