{ ... }:
{
  den.aspects.nvidia = {
    nixos =
      { pkgs, ... }:
      {
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.graphics.enable = true;
        hardware.nvidia = {
          open = true;
          powerManagement.enable = true;
          package = pkgs.linuxPackages.nvidiaPackages.beta;
          powerManagement.kernelSuspendNotifier = true;
        };
      };
  };
}
