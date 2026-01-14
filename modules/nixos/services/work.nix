{
  config,
  lib,
  pkgs,
  desktop,
  ...
}:
let
  cfg = config.custom.services.work;

  dotnet-combined = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_10_0
      sdk_9_0
      sdk_8_0
    ]
  );

  easydotnet = pkgs.buildDotnetGlobalTool {
    pname = "dotnet-easydotnet";
    nugetName = "EasyDotnet";
    version = "2.3.58";
    nugetHash = "sha256-pjGlLNdKDVRqZX6tpHroIXgHQgS8nCUgjRMp9li0BvA=";
    dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
  };
in
{
  options.custom.services.work = {
    enable = lib.mkEnableOption "work-related tools and services";

    enableAzurite = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Azurite Azure Storage Emulator service";
    };
  };

  config = lib.mkIf cfg.enable {
    services.twingate.enable = desktop;

    environment.systemPackages =
      with pkgs;
      [
        azure-cli
        azure-functions-core-tools
        azurite
        bicep
        dotnet-combined
        easydotnet
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

    systemd.services.azurite = lib.mkIf cfg.enableAzurite {
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

    users.users.azurite = lib.mkIf cfg.enableAzurite {
      isSystemUser = true;
      group = "azurite";
      description = "Azurite service user";
    };

    users.groups.azurite = lib.mkIf cfg.enableAzurite { };
  };
}
