{ ... }:

{
  imports = [
    ../../modules/networking.nix
    ../../modules/niri.nix
    ../../modules/zenbrowser.nix
    ./disable-dgpu.nix # OR ./hybrid-graphics.nix
    ./displaylink.nix
    ./hardware-configuration.nix
    ./power-management.nix
    ./secure-boot.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # enable "silent boot"
    consoleLogLevel = 3;
    loader.timeout = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

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
