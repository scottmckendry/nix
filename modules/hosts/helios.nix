{ den, inputs, ... }:
{
  den.aspects.helios = {
    includes = with den.aspects; [
      core
      docker
      go
      work
    ];

    homeManager =
      { ... }:
      {
        imports = [ ../../home/wsl ];
      };

    nixos =
      { lib, ... }:
      {
        imports = [ inputs.nixos-wsl.nixosModules.default ];

        wsl.enable = true;
        wsl.defaultUser = "scott";

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      };
  };
}
