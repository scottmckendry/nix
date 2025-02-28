{ pkgs, desktop, ... }:

let
  dotnet-combined = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_9_0
      sdk_8_0
    ]
  );
in
{
  services.twingate.enable = desktop;
  environment.systemPackages =
    with pkgs;
    [
      azure-cli
      azure-functions-core-tools
      azurite
      bicep
      csharpier
      dotnet-combined
    ]
    ++ (
      if desktop then
        [
          beekeeper-studio
          dbeaver-bin
          keepass
          libreoffice
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
