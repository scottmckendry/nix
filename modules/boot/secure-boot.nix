{ inputs, ... }:
{
  den.aspects.secure-boot = {
    nixos =
      { pkgs, lib, ... }:
      {
        imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

        # see https://github.com/nix-community/lanzaboote/blob/master/docs
        environment.systemPackages = [ pkgs.sbctl ];

        boot.loader.systemd-boot.enable = lib.mkForce false;
        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
  };
}
