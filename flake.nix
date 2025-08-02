{
  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nixos-wsl,
      nur,
      ...
    }@inputs:
    let
      username = "scott";
      name = "Scott McKendry";
      system = "x86_64-linux";
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    in
    {
      nixosConfigurations."atlas" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit name;
          inherit pkgs-stable;
          hostname = "atlas";
          desktop = true;
        };

        modules = [
          ./hosts
          home-manager.nixosModules.home-manager
          nur.modules.nixos.default
        ];
      };

      nixosConfigurations."helios" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit name;
          inherit pkgs-stable;
          hostname = "helios";
          desktop = false;
        };

        modules = [
          ./hosts
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cl-parse = {
      url = "github:scottmckendry/cl-parse";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pat = {
      url = "github:scottmckendry/pat";
    };

    pokemon-go-colorscripts = {
      url = "github:scottmckendry/pokemon-go-colorscripts";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:scottmckendry/zen-browser-flake";
    };
  };
}
