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
  imports = [
    ./bat.nix
    ./eza.nix
    ./git.nix
    ./lazygit.nix
    ./opencode.nix
    ./self-maintained.nix
    ./wslopen.nix
    ./yazi
    ./zsh.nix
  ]
  ++ (
    if desktop then
      [
        ./alacritty.nix
        ./desktopapps.nix
        ./gtk.nix
        ./kitty.nix
        ./niri
        ./walker.nix
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

  programs.fastfetch.enable = true;
  programs.gh.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    age
    air
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
    openssl
    powershell
    presenterm
    restic
    ripgrep
    sops
    sqlc
    sqlite
    tailwindcss_4
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
