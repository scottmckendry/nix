{ ... }:

{
  imports = [
    ../../modules/gaming.nix
    # ../../modules/hyprland.nix
    ../../modules/plasma.nix
    ../../modules/networking.nix
    ../../modules/nvidia.nix
    ../../modules/virtualisation.nix
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
