{ pkgs, config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  imports = [
    ./modules/home/lazygit.nix
    ./modules/home/hyprland.nix
  ];

  # symlinks
  xdg.configFile."bat".source = mkOutOfStoreSymlink "${nixDir}/bat";
  xdg.configFile."fastfetch".source = mkOutOfStoreSymlink "${nixDir}/fastfetch";
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixDir}/nvim";
  xdg.configFile."starship".source = mkOutOfStoreSymlink "${nixDir}/starship";

  programs.fastfetch.enable = true;
  programs.gh.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    bat
    brave
    cargo
    fd
    firefox
    fzf
    gcc
    gnumake
    go
    killall
    nautilus
    neovim
    nixfmt-rfc-style
    nodejs
    powershell
    ripgrep
    spotify
    unzip
    vesktop
    wezterm
    wget
    wl-clipboard
    zig
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
    shellAliases = {
      cd = "z";
      cdi = "zi";
      cat = "bat";
      rebuild = "cd ${nixDir} && git add -A -N && nh os switch . && cd -";
    };
    initExtra = ''
      fastfetch --logo ${nixDir}/fastfetch/logos/ascii.txt
    '';
  };

  programs.git = {
    enable = true;
    userName = "Scott McKendry";
    userEmail = "39483124+scottmckendry@users.noreply.github.com";
    aliases = {
      co = "checkout";
      hist = ''log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'';
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        syntax-theme = "cyberdream";
      };
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

  # bat setup
  home.activation.batSetup = config.lib.dag.entryBefore [ "writeBoundary" ] ''
    ${pkgs.bat}/bin/bat cache --clear
    ${pkgs.bat}/bin/bat cache --build
  '';

  # Do not modify state version
  home.stateVersion = "24.05";
}
