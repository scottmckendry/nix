{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    cl-parse.url = "github:scottmckendry/cl-parse";
    cyberdream.url = "github:scottmckendry/cyberdream.nvim";
    den.url = "github:vic/den";
    flake-aspects.url = "github:vic/flake-aspects";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager";
    import-tree.url = "github:vic/import-tree";
    lanzaboote.url = "github:nix-community/lanzaboote";
    niri-flake.url = "github:sodiboo/niri-flake";
    nix-cache.url = "github:scottmckendry/nix-cache";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    vicinae-extensions.url = "github:vicinaehq/extensions";
    zen-browser.url = "github:scottmckendry/zen-browser-flake";
  };
}
