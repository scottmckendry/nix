{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  custom.boot.silent.enable = true;
  custom.boot.silent.theme = "spinner";
  custom.desktop.gaming.enable = true;
  custom.desktop.niri.enable = true;
  custom.desktop.nvidia.enable = true;
  custom.services.docker.enable = true;
  custom.services.go.enable = true;
  custom.services.work.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
}
