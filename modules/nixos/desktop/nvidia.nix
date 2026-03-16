{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.nvidia;
in
{
  options.custom.desktop.nvidia = {
    enable = lib.mkEnableOption "NVIDIA drivers";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = true;
      powerManagement.enable = true;
      package = pkgs.linuxPackages.nvidiaPackages.beta;
      powerManagement.kernelSuspendNotifier = true;
    };
  };
}
