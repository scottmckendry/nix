{ den, ... }:
{
  den.aspects.eris = {
    includes = with den.aspects; [
      core
      displaylink
      docker
      hibernate
      intune
      networking
      niri
      niri-session
      nvidia
      packages
      secure-boot
      silent-boot
      swap
      tpm2-luks
      work
      work-desktop
      zsh
    ];

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
