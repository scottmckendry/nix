{ ... }:

{
  imports = [
    ../../modules/gaming.nix
    ../../modules/niri.nix
    ../../modules/networking.nix
    ../../modules/nvidia.nix
    ../../modules/virtualisation.nix
    ../../modules/zenbrowser.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
}
