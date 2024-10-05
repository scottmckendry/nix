{ ... }:

{
  imports = [
    ../../modules/gaming.nix
    ../../modules/hyprland.nix
    ../../modules/networking.nix
    ../../modules/nvidia.nix
    ../../modules/virtualisation.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
