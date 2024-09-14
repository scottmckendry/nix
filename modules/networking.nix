{ config, pkgs, ... }:
{
  networking.hostName = "atlas";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;
}
