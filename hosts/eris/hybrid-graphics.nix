{ ... }:

{
  imports = [
    ../../modules/nvidia.nix
  ];

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
}
