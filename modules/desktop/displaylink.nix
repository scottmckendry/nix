{ ... }:
{
  den.aspects.displaylink = {
    nixos =
      { pkgs, config, lib, ... }:
      {
        boot = {
          # TODO: evdi broken on 7.2; revert to linuxPackages_latest when fixed upstream
          kernelPackages = lib.mkForce pkgs.linuxPackages_7_1;
          extraModulePackages = [ config.boot.kernelPackages.evdi ];
          initrd.kernelModules = [ "evdi" ];
        };

        environment.systemPackages = [ pkgs.displaylink ];
        systemd.services.dlm.wantedBy = [ "multi-user.target" ];
        services.xserver.videoDrivers = [
          "modesetting"
          "displaylink"
        ];
      };
  };
}
