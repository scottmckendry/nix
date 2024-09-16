{ pkgs, ... }:
{
  services.twingate.enable = true;
  environment.systemPackages = with pkgs; [
    teams-for-linux
    remmina
    dbeaver-bin
  ];
}
