{
  config,
  lib,
  hostname,
  ...
}:
let
  cfg = config.custom.services.networking;
in
{
  options.custom.services.networking = {
    enable = lib.mkEnableOption "networking configuration" // {
      default = true;
    };

    devPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [
        3000
        1337
        8080
      ];
      description = "Common development ports to open in firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hostName = hostname;
    networking.networkmanager.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    networking.firewall.allowedTCPPorts = cfg.devPorts;
  };
}
