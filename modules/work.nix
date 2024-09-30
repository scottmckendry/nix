{ pkgs, desktop, ... }:

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
  environment.systemPackages =
    with pkgs;
    [
      azure-cli
      bicep
      dotnet-combined
    ]
    ++ (
      if desktop then
        [
          # desktop apps
          beekeeper-studio
          dbeaver-bin
          remmina
          teams-for-linux
        ]
      else
        [ ]
    );

  environment.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}";
  };
}
