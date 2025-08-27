{ config, pkgs, ... }:

{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd = {
      kernelModules = [
        "evdi"
      ];
    };
  };

  environment.systemPackages = [ pkgs.displaylink ];
  systemd.services.dlm.wantedBy = [ "multi-user.target" ];
  services.xserver.videoDrivers = [
    "modesetting"
    "displaylink"
  ];
}
