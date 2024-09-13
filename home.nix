{ pkgs, ... }:

{
  imports = [
    ./modules/stylix.nix
  ];

  programs.zoxide.enable = true;
  programs.gh.enable = true;
  programs.lazygit.enable = true;
  programs.starship.enable = true;
  programs.fuzzel.enable = true;
  programs.waybar.enable = true;
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
    swappy
    teams-for-linux
    unzip
    waybar
    wget
    wl-clipboard
    wlogout
    zig
  ];

  xdg.desktopEntries = {
    discord = {
      name = "Discord";
      genericName = "Discord";
      comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
      icon = "discord";
      exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
      terminal = false;
      categories = [
        "Network"
        "InstantMessaging"
      ];
    };
  };

  xdg.configFile."swappy/config".text = ''
    [Default]
    early_exit=true
  '';

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
      hist = ''log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'';
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
    };
  };

  # Do not modify state version
  home.stateVersion = "24.05";
}
