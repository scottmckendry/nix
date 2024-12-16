{ pkgs, desktop, ... }:

let
  dotnet-combined = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_9_0
      sdk_8_0
      sdk_6_0
    ]
  );
in
{
  services.twingate.enable = desktop;
  environment.systemPackages =
    with pkgs;
    [
      azure-cli
      bicep
      dotnet-combined
      roslyn-ls
      libreoffice
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

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
  ];
  environment.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}";
  };
}
