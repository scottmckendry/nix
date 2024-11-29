{ pkgs, inputs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = [
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
  ];
}