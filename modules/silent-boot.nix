{ ... }:
{
  den.aspects.silent-boot = {
    includes = [
      (
        { host, ... }:
        {
          nixos.boot.plymouth.theme = host.plymouthTheme or "spinner";
        }
      )
    ];

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
            "splash"
            "boot.shell_on_fail"
            "udev.log_priority=3"
            "rd.systemd.show_status=auto"
          ];
          plymouth.enable = true;
        };
      };
  };
}
