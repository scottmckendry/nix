{ pkgs, ... }:

{
  imports = [
    ./waybar/waybar.nix
    ./modules/dconf.nix
  ];

  programs.zoxide.enable = true;
  programs.gh.enable = true;
  programs.lazygit.enable = true;
  programs.starship.enable = true;
  programs.fuzzel.enable = true;
  services.hyprpaper.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    bat
    brave
    cargo
    cliphist
    discord
    dolphin
    dunst
    fastfetch
    fd
    firefox
    fzf
    gcc
    gnumake
    go
    grim
    gnome-tweaks
    dconf-editor
    hypridle
    hyprlock
    hyprpaper
    inotify-tools
    killall
    neovim
    nixfmt-rfc-style
    nodejs
    pamixer
    pavucontrol
    playerctl
    powershell
    ripgrep
    slurp
    spotify
    sqlite
    unzip
    wget
    wl-clipboard
    wlogout
    wezterm
    zig
  ];

  programs.bash = {
    enable = true;

    shellAliases = {
      cd = "z";
      cdi = "zi";

      rebuild = "nh os switch $HOME/git/nix";
    };
  };

  programs.git = {
    enable = true;
    userName = "Scott McKendry";
    userEmail = "39483124+scottmckendry@users.noreply.github.com";
    aliases = {
      co = "checkout";
      hist = ''log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'';
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
        padding = {
          x = 10;
          y = 10;
        };
        dimensions = {
          columns = 180;
          lines = 45;
        };
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
    };
  };

  # Do not modify state version
  home.stateVersion = "24.05";
}
