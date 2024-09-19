{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      stylix,
      home-manager,
      nixos-cosmic,
      ...
    }:
    {
      nixosConfigurations."atlas" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          stylix.nixosModules.stylix
          nixos-cosmic.nixosModules.default
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.scott = {
              imports = [ ./home.nix ];
            };
          }
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };
}
