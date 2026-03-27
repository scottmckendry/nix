{ inputs, ... }:
{
  den.aspects.work = {
    nixos =
      { pkgs, ... }:
      let
        azure-cli-stable =
          inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.azure-cli;

        dotnet-combined =
          with pkgs.dotnetCorePackages;
          combinePackages [
            sdk_10_0
            sdk_9_0
            sdk_8_0
          ];

        azureFunctionsPatched = pkgs.writeShellScriptBin "func" ''
          export DOTNET_ROOT="${dotnet-combined}/share/dotnet"
          export DOTNET_ROOT_X64="$DOTNET_ROOT"
          export DOTNET_MULTILEVEL_LOOKUP=0
          exec "${pkgs.azure-functions-core-tools}/bin/func" "$@"
        '';

        easydotnet = pkgs.buildDotnetGlobalTool {
          pname = "dotnet-easydotnet";
          nugetName = "EasyDotnet";
          version = "2.3.58";
          nugetHash = "sha256-pjGlLNdKDVRqZX6tpHroIXgHQgS8nCUgjRMp9li0BvA=";
          dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
        };
      in
      {
        environment.systemPackages = with pkgs; [
          (azure-cli-stable.withExtensions [ azure-cli-stable.extensions.ssh ])
          azureFunctionsPatched
          azurite
          bicep
          dotnet-combined
          easydotnet
        ];

        environment.sessionVariables = {
          DOTNET_ROOT = "${dotnet-combined}/share/dotnet";
          DOTNET_ROOT_X64 = "${dotnet-combined}/share/dotnet";
          DOTNET_MULTILEVEL_LOOKUP = "0";
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
      };
  };

  den.aspects.work-desktop = {
    nixos =
      { pkgs, ... }:
      {
        services.twingate.enable = true;

        environment.systemPackages = with pkgs; [
          dbeaver-bin
          keepass
          keepassxc
          libreoffice
          remmina
          teams-for-linux
        ];
      };
  };
}
