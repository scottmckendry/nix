{ inputs, ... }:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ./disable-dgpu.nix # OR ./hybrid-graphics.nix
    ./displaylink.nix
    ./hardware-configuration.nix
    ./power-management.nix
    ./secure-boot.nix
  ];

  custom.boot.silent.enable = true;
  custom.boot.silent.theme = "fade-in";
  custom.desktop.niri.enable = true;
  custom.services.docker.enable = true;
  custom.services.go.enable = true;
  custom.services.virtualisation.enable = true;
  custom.services.work.enable = true;

  # Touchpad sensitivity overrides
  # see https://wayland.freedesktop.org/libinput/doc/latest/touchpad-pressure-debugging.html
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Touchpad Sensitivity Overrides]
    MatchVendor=0x045E
    MatchProduct=0x09AF
    MatchUdevType=touchpad
    AttrPressureRange=5:3
    AttrPalmPressureThreshold=500
  '';
}
