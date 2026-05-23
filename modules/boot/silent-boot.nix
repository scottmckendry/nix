{ ... }:
{
  den.aspects.silent-boot = {
    nixos =
      { ... }:
      {
        boot = {
          loader.systemd-boot.enable = true;
          loader.efi.canTouchEfiVariables = true;
          consoleLogLevel = 3;
          loader.timeout = 0;
          initrd.verbose = false;
          kernelParams = [
            "quiet"
            "boot.shell_on_fail"
            "udev.log_priority=3"
            "rd.systemd.show_status=auto"
          ];
        };
      };
  };
}
