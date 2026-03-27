{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.desktop.displaylink;
in
{
  options.custom.desktop.displaylink = {
    enable = lib.mkEnableOption "displaylink drivers for compatible docks";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
