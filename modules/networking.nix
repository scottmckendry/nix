{ hostname, ... }:
{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # common ports for development - nice for mobile device testing
  networking.firewall.allowedTCPPorts = [
    3000
    1337
    8080
  ];
}
