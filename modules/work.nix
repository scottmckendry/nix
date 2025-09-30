{
  pkgs,
  pkgs-stable,
  desktop,
  ...
}:

let
  teams-for-linux = pkgs.callPackage ../pkgs/teams-for-linux.nix { };
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
      pkgs-stable.azure-cli
      azure-functions-core-tools
      azurite
      bicep
      dotnet-combined
    ]
    ++ (
      if desktop then
        [
          dbeaver-bin
          keepass
          keepassxc
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

  systemd.services.azurite = {
    description = "Azurite Azure Storage Emulator";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.azurite}/bin/azurite";
      Restart = "always";
      User = "azurite";
      Group = "azurite";
      StateDirectory = "azurite";
      WorkingDirectory = "/var/lib/azurite";
    };
  };

  users.users.azurite = {
    isSystemUser = true;
    group = "azurite";
    description = "Azurite service user";
  };

  users.groups.azurite = { };
}
