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
  boot.kernelParams = [ "resume_offset=36454400" ];
  boot.resumeDevice = "/dev/disk/by-uuid/1307e52a-da90-4c68-9a88-1180e1bcdd0f";
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  environment.systemPackages = [ pkgs.powertop ];

  services.power-profiles-daemon.enable = true;

  systemd.sleep.extraConfig = "HibernateDelaySec=30m";
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "poweroff";
  };
}
