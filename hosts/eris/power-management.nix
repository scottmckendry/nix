{ pkgs, ... }:

{
  # Enable deep sleep mode with hibernation support - requires swap space
  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
    }
  ];

  # Enable resume from swapfile for hibernation
  boot.kernelParams = [ "resume_offset=14282244" ];
  boot.resumeDevice = "/dev/mapper/luks-0074ecff-31d1-498a-9571-b38b8b85a1fd";
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
}
