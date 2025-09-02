{
  outputs =
    {
      home-manager,
      lanzaboote,
      niri,
      nixos-wsl,
      nixpkgs,
      nixpkgs-stable,
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
          niri.nixosModules.niri
        ];
      };

      nixosConfigurations."eris" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit name;
          inherit pkgs-stable;
          hostname = "eris";
          desktop = true;
        };

        modules = [
          ./hosts
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
          niri.nixosModules.niri
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
    nixpkgs.url = "github:dramforever/nixpkgs/evdi-flags-fix";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    cl-parse = {
      url = "github:scottmckendry/cl-parse";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-override = {
      url = "github:scottmckendry/niri/primary-render-fallback";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };

    pat = {
      url = "github:scottmckendry/pat";
    };

    pokemon-go-colorscripts = {
      url = "github:scottmckendry/pokemon-go-colorscripts";
    };

    sunsetr = {
      url = "github:psi4j/sunsetr";
    };

    zen-browser = {
      url = "github:scottmckendry/zen-browser-flake";
    };
  };
}
