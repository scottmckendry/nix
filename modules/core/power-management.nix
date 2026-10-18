{ ... }:
{
  den.aspects.power-management = {
    includes = [
      (
        { host, ... }:
        {
          nixos.boot.kernelParams = [
            "resume_offset=${toString host.swapResumeOffset}"
          ];
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
          pd.enable = true;
          settings = {
            USB_DENYLIST = "3554:f58a"; # VXE Mouse
            WIFI_PWR_ON_AC = "off";
            WIFI_PWR_ON_BAT = "on";
            PCIE_ASPM_ON_BAT = "powersupersave";
            PLATFORM_PROFILE_ON_BAT = "low-power";
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
