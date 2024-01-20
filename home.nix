{ config, pkgs, ... }:

{
  imports = [
    ./rofi/rofi.nix
  ];

  programs.zoxide.enable = true;
  programs.gh.enable = true;

  home.sessionVariables = {
    GTK_THEME = "Adementary-dark";
  };

  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  gtk.enable = true;
  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Classic";
  gtk.theme.package = pkgs.adementary-theme;
  gtk.theme.name = "Adementary-dark";
  gtk.iconTheme.package = pkgs.gnome.adwaita-icon-theme;
  gtk.iconTheme.name = "Adwaita-dark";

  xdg.desktopEntries = {
    discord = {
      name = "Discord";
      genericName = "Discord";
      comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
      icon = "discord";
      exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
      terminal = false;
      categories = [ "Network" "InstantMessaging" ];
    };
  };

  xdg.configFile."swappy/config".text = ''
    [Default]
    early_exit=true
  '';

  programs.swaylock = {
    enable = true;
    # This fork is more stable than the one available in nixpkgs - fixes red screen of death
    package = pkgs.swaylock-effects.overrideAttrs
      (_: {
        src = pkgs.fetchFromGitHub {
          owner = "jirutka";
          repo = "swaylock-effects";
          rev = "v1.7.0.0";
          sha256 = "cuFM+cbUmGfI1EZu7zOsQUj4rA4Uc4nUXcvIfttf9zE=";
        };
      });
    settings = {
      screenshots = true;
      indicator = true;
      indicator-radius = 120;
      font = "JetBrains Mono Nerd Font";
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      fade-in = 0.2;

      clock = true;
      timestr = "%I:%M:%S %p";
      datestr = "%a, %d %b %Y";

      # colors
      text-color = "#ffffff";
      text-clear-color = "#ffffff";
      text-ver-color = "#5ef1ff";
      text-wrong-color = "#ff6e5e";

      ring-color = "#00000000";
      key-hl-color = "#00000000";
      bs-hl-color = "#00000000";
      line-color = "#00000000";
      inside-color = "#00000000";
      separator-color = "#00000000";

      inside-clear-color = "#00000000";
      line-clear-color = "#00000000";
      ring-clear-color = "#00000000";

      inside-ver-color = "#00000000";
      line-ver-color = "#00000000";
      ring-ver-color = "#00000000";

      inside-wrong-color = "#00000000";
      line-wrong-color = "#00000000";
      ring-wrong-color = "#00000000";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "skip";
      gui = {
        nerdFontsVersion = "3";
        showBottomLine = false;
        border = "rounded";
        mouseEvents = false;

        theme = {
          activeBorderColor = [ "cyan" ];
          inactiveBorderColor = [ "magenta" ];
        };
      };
      git = {
        parseEmoji = true;
      };
    };
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      cd = "z";
      cdi = "zi";

      rebuild = "sudo nixos-rebuild switch";
    };
  };

  programs.git = {
    enable = true;
    userName = "Scott McKendry";
    userEmail = "39483124+scottmckendry@users.noreply.github.com";
    aliases = {
      co = "checkout";
      hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 10;
        normal = {
          family = "JetBrains Mono Nerd Font";
        };
      };
      window = {
        opacity = 0.9;
        padding = {
          x = 10;
          y = 10;
        };
      };
      colors = {
        primary = {
          background = "#16181a";
          foreground = "#ffffff";
        };
        normal = {
          black = "#16181a";
          red = "#ff6e5e";
          green = "#5eff6c";
          yellow = "#f1ff5e";
          blue = "#5ea1ff";
          magenta = "#bd5eff";
          cyan = "#5ef1ff";
          white = "#ffffff";
        };
        bright = {
          black = "#3c4048";
          red = "#ff6e5e";
          green = "#5eff6c";
          yellow = "#f1ff5e";
          blue = "#5ea1ff";
          magenta = "#bd5eff";
          cyan = "#5ef1ff";
          white = "#ffffff";
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[ ](bold red)";
      };
      cmd_duration = {
        min_time = 200;
        show_milliseconds = true;
      };
      golang = {
        symbol = " ";
      };
      nodejs = {
        detect_extensions = [ ];
      };
      git_metrics = {
        disabled = false;
        format = "(([ $added]($added_style)) ([ $deleted]($deleted_style)))";
        only_nonzero_diffs = true;
      };
      line_break = {
        disabled = true;
      };
      jobs = {
        disabled = true;
      };
      env_var = {
        UpdatesPending = {
          variable = "UpdatesPending";
          format = "[$env_value]($style)";
          default = "";
          style = "bold cyan";
        };
      };
    };
  };

  # Do not modify state version
  home.stateVersion = "23.11";
}
