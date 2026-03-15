{ pkgs, ... }:

{
  custom.desktop.nvidia.enable = true;
  hardware.nvidia = {
    package = pkgs.linuxPackages.nvidiaPackages.beta;
    powerManagement.finegrained = true;
    powerManagement.kernelSuspendNotifier = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:243:00:0";
    };
  };
}
