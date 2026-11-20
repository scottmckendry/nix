{
  outputs =
    inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [ (import ./utils/import-tree.nix ./modules) ];
      specialArgs.inputs = inputs;
    }).config.flake;

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    cyberdream = {
      url = "github:scottmckendry/cyberdream.nvim";
    };

    den = {
      url = "github:vic/den";
    };

    flakemill = {
      url = "github:scottmckendry/flakemill";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haunt = {
      url = "github:scottmckendry/haunt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iets = {
      url = "github:numtide/iets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
