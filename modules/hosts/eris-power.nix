{ ... }:
{
  den.aspects.hibernate = {
    includes = [
      (
        { host, ... }:
        {
          nixos.boot.kernelParams = [ "resume_offset=${toString host.swapResumeOffset}" ];
          nixos.boot.resumeDevice = "/dev/mapper/${builtins.head (host.luksDevices or [ "" ])}";
        }
      )
    ];

    nixos =
      { ... }:
      {
        powerManagement.enable = true;
        services.tlp = {
          enable = true;
          settings = {
            USB_DENYLIST = "3554:f58a"; # VXE Mouse
          };
        };
        services.power-profiles-daemon.enable = false; # conflicts with TLP
        systemd.sleep.settings.Sleep = {
          AllowHibernation = "yes";
          HibernateMode = "platform shutdown";
          HibernateDelaySec = "30m";
        };
        services.logind.settings.Login = {
          HandleLidSwitch = "suspend-then-hibernate";
          HandleLidSwitchExternalPower = "ignore";
          HandlePowerKey = "ignore";
          HandlePowerKeyLongPress = "poweroff";
        };
      };
  };
}
