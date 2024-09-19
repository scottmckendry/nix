{ pkgs, ... }:
{
  services.twingate.enable = true;
  environment.systemPackages = with pkgs; [
    azure-cli
    bicep
    dbeaver-bin
    dotnet-sdk_8
    remmina
    teams-for-linux
  ];
}
