{ den, ... }:
{
  den.aspects.atlas = {
    includes = with den.aspects; [
      core
      networking
      silent-boot
      niri
      nvidia
      gaming
      docker
      go
      work
      work-desktop
    ];

    provides.to-users =
      { host, ... }:
      {
        homeManager.imports = [ ../../home/desktop ];
        homeManager.programs.hyprlock.settings.input-field.monitor = host.output or "";
        homeManager.programs.hyprlock.settings.label.monitor = host.output or "";
      };

    nixos =
      {
        modulesPath,
        config,
        lib,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "usb_storage"
          "usbhid"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/ce09784e-2da3-4577-b431-d1f12a815565";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/6D05-AF4C";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [
          {
            device = "/swapfile";
            size = 16 * 1024;
          }
        ];

        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
  };
}
