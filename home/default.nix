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
  cl-parse = inputs.cl-parse.packages.${pkgs.stdenv.hostPlatform.system}.default;
  cyberdream = pkgs.fetchFromGitHub {
    owner = "scottmckendry";
    repo = "cyberdream.nvim";
    rev = "main";
    sha256 = "sha256-iU4HgEzjcZ/UE+aapTGWRcilaLmUy/QQnuIaTFT63Zg=";
  };
in
{
  _module.args = { inherit cyberdream; };

  imports = [
    ./bat.nix
    ./eza.nix
    ./git.nix
    ./k9s.nix
    ./lazygit.nix
    ./opencode.nix
    ./posting.nix
    ./starship.nix
    ./wslopen.nix
    ./yazi.nix
    ./zsh.nix
  ]
  ++ (
    if desktop then
      [
        ./defaultapps.nix
        ./desktopapps.nix
        ./gtk.nix
        ./kitty.nix
        ./foot.nix
        ./niri
        ./webapps.nix
      ]
    else
      [ ]
  );

  # symlinks
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixDir}/nvim";
  home.file."scripts".source = mkOutOfStoreSymlink "${nixDir}/scripts";

  programs.fastfetch.enable = true;
  programs.zoxide.enable = true;

  programs.gh.enable = true;
  programs.gh.extensions = [ pkgs.gh-markdown-preview ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    age
    air
    ansible
    appimage-run
    btop
    calibre
    cargo
    cl-parse
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
    nix-index
    nixfmt
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
    typst
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
