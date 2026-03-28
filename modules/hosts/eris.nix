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
      niri-session
      nvidia
      displaylink
      docker
      packages
      intune
      work
      work-desktop
      swap
      hibernate
    ];

    provides.to-users =
      { host, ... }:
      {
        homeManager.imports = [ ../../home/desktop ];
        homeManager.programs.hyprlock.settings.input-field.monitor = host.output or "";
        homeManager.programs.hyprlock.settings.label.monitor = host.output or "";
      };

    nixos =
      { config, lib, ... }:
      {
        imports = [
          ./_eris-hardware.nix
        ];

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
