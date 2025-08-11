{ ... }:

{
  imports = [
    ../../modules/networking.nix
    ../../modules/niri.nix
    ../../modules/nvidia.nix
    ../../modules/zenbrowser.nix
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

  # hybrid graphics - see https://nixos.wiki/wiki/Nvidia
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:243:00:0";
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
