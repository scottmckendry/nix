{ ... }:

{
  imports = [
    ../../modules/gaming.nix
    ../../modules/niri.nix
    ../../modules/networking.nix
    ../../modules/nvidia.nix
    # ../../modules/virtualisation.nix
    ../../modules/zenbrowser.nix
    ./hardware-configuration.nix
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

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
}
