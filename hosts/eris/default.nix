{ ... }:
{
  imports = [
    ./hybrid-graphics.nix
    ./hardware-configuration.nix
    ./power-management.nix
  ];

  custom.boot.secure-boot.enable = true;
  custom.boot.silent.enable = true;
  custom.boot.silent.theme = "fade-in";
  custom.desktop.displaylink.enable = true;
  custom.desktop.niri.enable = true;
  custom.services.docker.enable = true;
  custom.services.go.enable = true;
  custom.services.intune.enable = true;
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
