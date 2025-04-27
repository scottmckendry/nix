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
          # ./anyrun
          # ./hyprland
          ./alacritty.nix
          ./desktopapps.nix
          ./kitty.nix
        ]
      else
        [ ]
    );

  # symlinks
  xdg.configFile."fastfetch".source = mkOutOfStoreSymlink "${nixDir}/fastfetch";
  xdg.configFile."k9s".source = mkOutOfStoreSymlink "${nixDir}/k9s";
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
    age
    ansible
    appimage-run
    btop
    fd
    fluxcd
    fzf
    gcc
    gnumake
    go-task
    hugo
    k9s
    killall
    kubectl
    mermaid-cli
    neovim
    nil
    nixfmt-rfc-style
    nodejs
    odin
    powershell
    presenterm
    restic
    ripgrep
    sops
    talosctl
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
