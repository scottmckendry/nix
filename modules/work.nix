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
      roslyn-ls
    ]
    ++ (
      if desktop then
        [
          beekeeper-studio
          dbeaver-bin
          remmina
          teams-for-linux
          keepass
        ]
      else
        [ ]
    );

  environment.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}";
  };
}
