{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    cl-parse = {
      url = "github:scottmckendry/cl-parse";
    };

    cyberdream = {
      url = "github:scottmckendry/cyberdream.nvim";
    };

    den = {
      url = "github:vic/den";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree = {
      url = "github:vic/import-tree";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cache = {
      url = "github:scottmckendry/nix-cache";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:scottmckendry/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
