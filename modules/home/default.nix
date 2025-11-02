{
  pkgs,
  config,
  inputs,
  desktop,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
  neovim = inputs.neovim-nightly.packages.${pkgs.system}.default;
in
{
  imports = [
    ./bat.nix
    ./eza.nix
    ./git.nix
    ./opencode.nix
    ./posting.nix
    ./self-maintained.nix
    ./wslopen.nix
    ./yazi
    ./zsh.nix
  ]
  ++ (
    if desktop then
      [
        ./desktopapps.nix
        ./gtk.nix
        ./kitty.nix
        ./foot.nix
        ./niri
        ./vicinae.nix
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
  home.file."scripts".source = mkOutOfStoreSymlink "${nixDir}/scripts";

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
    calibre
    cargo
    fd
    fluxcd
    fzf
    gcc
    ghostscript
    gnumake
    go-task
    hugo
    jq
    k9s
    killall
    kubectl
    mermaid-cli
    neovim
    nil
    nixfmt-rfc-style
    nixpkgs-review
    nodejs
    odin
    openssl
    powershell
    presenterm
    python3
    restic
    ripgrep
    rustc
    rustfmt
    sops
    sqlc
    sqlite
    tailwindcss_4
    talosctl
    tdf
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
