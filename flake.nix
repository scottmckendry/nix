{
  outputs =
    {
      nixpkgs,
      stylix,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations."atlas" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./configuration.nix
          ./hardware-configuration.nix

          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.scott = {
                imports = [ ./home.nix ];
              };

              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    stylix = {
      url = "github:danth/stylix";
    };
  };
}
