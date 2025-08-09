{ pkgs, ... }:

{
  imports = [
    ../../modules/gaming.nix
    ../../modules/networking.nix
    ../../modules/niri.nix
    ../../modules/nvidia.nix
    ../../modules/virtualisation.nix
    ../../modules/zenbrowser.nix
    ./hardware-configuration.nix
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

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
}
