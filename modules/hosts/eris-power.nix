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
      { pkgs, ... }:
      {
        powerManagement.enable = true;
        powerManagement.powertop.enable = true;
        environment.systemPackages = [ pkgs.powertop ];

        services.power-profiles-daemon.enable = true;

        systemd.sleep.settings.Sleep = {
          AllowHibernation = "yes";
          HibernateMode = "platform shutdown";
          HibernateDelaySec = "30m";
        };
        services.logind.settings.Login = {
          HandleLidSwitch = "suspend-then-hibernate";
          HandlePowerKey = "ignore";
          HandlePowerKeyLongPress = "poweroff";
        };
      };
  };
}
