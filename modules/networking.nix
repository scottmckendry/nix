{ ... }:
{
  den.aspects.networking = {
    includes = [
      (
        { host, ... }:
        {
          nixos.networking.hostName = host.hostName;
        }
      )
    ];

    nixos =
      { ... }:
      {
        networking.networkmanager.enable = true;

        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = true;

        # useful ports to open for web dev
        networking.firewall.allowedTCPPorts = [
          3000
          1337
          8080
        ];
      };
  };
}
