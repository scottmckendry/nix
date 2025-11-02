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
      pkgs-stable = nixpkgs-stable.legacyPackages.${"x86_64-linux"};
      mkHost =
        {
          hostname,
          desktop,
          extraModules,
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit name;
            inherit pkgs-stable;
            inherit hostname;
            inherit desktop;
          };

          modules = [
            ./hosts
            home-manager.nixosModules.home-manager
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        "atlas" = mkHost {
          hostname = "atlas";
          desktop = true;
          extraModules = [ niri.nixosModules.niri ];
        };

        "eris" = mkHost {
          hostname = "eris";
          desktop = true;
          extraModules = [
            lanzaboote.nixosModules.lanzaboote
            niri.nixosModules.niri
          ];
        };

        "helios" = mkHost {
          hostname = "helios";
          desktop = false;
          extraModules = [ nixos-wsl.nixosModules.default ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
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

    vicinae = {
      url = "github:vicinaehq/vicinae";
    };

    zen-browser = {
      url = "github:scottmckendry/zen-browser-flake";
    };
  };
}
