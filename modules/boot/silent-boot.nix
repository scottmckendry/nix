{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.boot.silent;
in
{
  options.custom.boot.silent = {
    enable = lib.mkEnableOption "silent boot configuration";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "spinner";
      description = "Plymouth theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;

      consoleLogLevel = 3;
      loader.timeout = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];

      plymouth = {
        enable = true;
        theme = cfg.theme;
      };
    };
  };
}
