{ ... }:

{
  imports = [
    ../../modules/gaming.nix
    ../../modules/niri.nix
    ../../modules/networking.nix
    ../../modules/nvidia.nix
    ../../modules/virtualisation.nix
    ../../modules/zenbrowser.nix
    ./hardware-configuration.nix
  ];

  # https://wiki.nixos.org/wiki/Plymouth
  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # enable "silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
}
