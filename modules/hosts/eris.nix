{ den, ... }:
{
  den.aspects.eris = {
    includes = with den.aspects; [
      core
      networking
      silent-boot
      secure-boot
      tpm2-luks
      niri
      nvidia
      displaylink
      docker
      go
      work
      work-desktop
      intune
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
        pkgs,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = [
          "xhci_pci"
          "thunderbolt"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/mapper/luks-0074ecff-31d1-498a-9571-b38b8b85a1fd";
          fsType = "btrfs";
          options = [ "subvol=@" ];
        };

        boot.initrd.luks.devices."luks-0074ecff-31d1-498a-9571-b38b8b85a1fd".device =
          "/dev/disk/by-uuid/0074ecff-31d1-498a-9571-b38b8b85a1fd";

        fileSystems."/home" = {
          device = "/dev/mapper/luks-0074ecff-31d1-498a-9571-b38b8b85a1fd";
          fsType = "btrfs";
          options = [ "subvol=@home" ];
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/989B-9ED0";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [
          {
            device = "/swapfile";
            size = 32 * 1024;
          }
        ];

        # Hibernation support
        boot.kernelParams = [
          "resume_offset=14282244"
        ];
        boot.resumeDevice = "/dev/mapper/luks-0074ecff-31d1-498a-9571-b38b8b85a1fd";
        powerManagement.enable = true;
        powerManagement.powertop.enable = true;
        environment.systemPackages = [ pkgs.powertop ];
        services.power-profiles-daemon.enable = true;

        systemd.sleep.settings.Sleep = {
          AllowHibernation = "yes";
          HibernateMode = "platform shutdown";
          HibernateDelaySec = "30m";
        };
        services.logind.settings.Login = {
          HandleLidSwitch = "suspend-then-hibernate";
          HandlePowerKey = "ignore";
          HandlePowerKeyLongPress = "poweroff";
        };

        # NVIDIA PRIME (hybrid graphics)
        hardware.nvidia = {
          powerManagement.finegrained = true;
          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            intelBusId = "PCI:00:02:0";
            nvidiaBusId = "PCI:243:00:0";
          };
        };

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

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
  };
}
