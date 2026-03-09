{ ... }:

{
  custom.desktop.nvidia.enable = true;
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:243:00:0";
  };
}
