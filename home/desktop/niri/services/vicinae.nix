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
        opacity = 1.0;
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
