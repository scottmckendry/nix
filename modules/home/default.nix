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
      ./wslopen.nix
      ./yazi
      ./zsh.nix
    ]
    ++ (
      if desktop then
        [
          ./hyprland
          ./alacritty.nix
          ./anyrun
          ./desktopapps.nix
          ./kitty.nix
        ]
      else
        [ ]
    );

  # symlinks
  xdg.configFile."fastfetch".source = mkOutOfStoreSymlink "${nixDir}/fastfetch";
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixDir}/nvim";
  xdg.configFile."starship".source = mkOutOfStoreSymlink "${nixDir}/starship";
  xdg.configFile."wezterm".source = mkOutOfStoreSymlink "${nixDir}/wezterm";

  programs.eza.enable = true;
  programs.fastfetch.enable = true;
  programs.gh.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    ansible
    appimage-run
    btop
    fd
    fzf
    gcc
    gnumake
    go-task
    hugo
    killall
    mermaid-cli
    neovim
    nil
    nixfmt-rfc-style
    nodejs
    odin
    powershell
    presenterm
    ripgrep
    terraform
    typescript
    unzip
    wezterm
    wget
    zig
  ];

  home.sessionVariables = {
    OBSIDIAN_PATH = "${config.home.homeDirectory}/git/obsidian-vault";
  };

  home.stateVersion = "24.05";
}
