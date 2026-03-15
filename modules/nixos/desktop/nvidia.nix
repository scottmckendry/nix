{
  config,
  lib,
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
    hardware.nvidia.open = true;
    hardware.nvidia.powerManagement.enable = true;
  };
}
