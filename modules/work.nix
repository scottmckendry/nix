{ pkgs, ... }:

let
  dotnet-combined = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_6_0
    ]
  );
in
{
  services.twingate.enable = true;
  environment.systemPackages = with pkgs; [
    azure-cli
    bicep
    dbeaver-bin
    dotnet-combined
    remmina
    teams-for-linux
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}";
  };
}
