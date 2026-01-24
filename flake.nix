{
  outputs =
    {
      home-manager,
      nixos-wsl,
      nixpkgs,
      ...
    }@inputs:
    let
      username = "scott";
      mkHost =
        { hostname, desktop }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              username
              hostname
              desktop
              ;
          };

          modules = [
            ./hosts
            home-manager.nixosModules.home-manager
          ];
        };
      homeConfiguration = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        extraSpecialArgs = {
          inherit inputs username;
          desktop = false;
        };

        modules = [ ./home ];
      };
    in
    {
      nixosConfigurations = {
        "atlas" = mkHost {
          hostname = "atlas";
          desktop = true;
        };

        "eris" = mkHost {
          hostname = "eris";
          desktop = true;
        };

        "helios" = mkHost {
          hostname = "helios";
          desktop = false;
        };
      };

      homeConfigurations = {
        "default" = homeConfiguration;
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    cl-parse = {
      url = "github:scottmckendry/cl-parse";
    };

    cyberdream = {
      url = "github:scottmckendry/cyberdream.nvim";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
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
