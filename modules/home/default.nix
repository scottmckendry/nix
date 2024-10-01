{
  pkgs,
  config,
  desktop,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  imports =
    [
      ./bat.nix
      ./git.nix
      ./lazygit.nix
      ./yazi
      ./zsh.nix
    ]
    ++ (
      if desktop then
        [
          ./hyprland
          ./desktopapps.nix
          ./alacritty.nix
        ]
      else
        [ ]
    );

  # symlinks
  xdg.configFile."fastfetch".source = mkOutOfStoreSymlink "${nixDir}/fastfetch";
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixDir}/nvim";
  xdg.configFile."starship".source = mkOutOfStoreSymlink "${nixDir}/starship";

  programs.eza.enable = true;
  programs.fastfetch.enable = true;
  programs.gh.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    cargo
    fd
    fzf
    gcc
    gnumake
    go
    killall
    neovim
    nixfmt-rfc-style
    nodejs
    powershell
    ripgrep
    unzip
    wezterm
    wget
    zig
  ];

  # Do not modify state version
  home.stateVersion = "24.05";
}
