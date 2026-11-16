{ inputs, ... }:
{
  den.aspects.flakemill = {
    nixos =
      {
        config,
        host,
        lib,
        pkgs,
        ...
      }:
      let
        mill = host.settings.fleet.flakemill;
        user = config.users.users.${host.settings.fleet.primaryUser};
        repo = host.settings.fleet.repoRoot;
        cacheDir = "${user.home}/.cache";
        statusFile = "${cacheDir}/nix-update-status";
        statusTmp = "${statusFile}.tmp";
        millPubKey = pkgs.writeText "flakemill.pub" mill.publicKey;
        flakemill = inputs.flakemill.packages.${pkgs.stdenv.hostPlatform.system}.flakemill;
        indicator = "";
        clientEnv = {
          FLAKEMILL_URL = mill.url;
          FLAKEMILL_PUBLIC_KEY = "${millPubKey}";
          FLAKEMILL_LOCK = "${repo}/flake.lock";
        };

        nix-update-check = pkgs.writeShellApplication {
          name = "nix-update-check";
          runtimeInputs = [
            pkgs.coreutils
            flakemill
          ];
          text = ''
            mkdir -p ${lib.escapeShellArg cacheDir}

            # check exits 0 when up to date, 1 when an update is available,
            # and 2 on error.
            if flakemill check --quiet; then
              rm -f ${lib.escapeShellArg statusFile}
            else
              rc=$?
              if [ "$rc" -ne 1 ]; then
                exit "$rc"
              fi
              printf '%s' ${lib.escapeShellArg indicator} > ${lib.escapeShellArg statusTmp}
              mv -f ${lib.escapeShellArg statusTmp} ${lib.escapeShellArg statusFile}
            fi
          '';
        };
      in
      lib.mkIf (mill != null) {
        programs.starship.settings.custom.nix = {
          when = "test -e ${lib.escapeShellArg statusFile}";
          symbol = indicator;
          style = "bold yellow";
          format = "[$symbol]($style) ";
        };

        environment.systemPackages = [ flakemill ];
        environment.variables = clientEnv;

        systemd.timers.nix-update-check = {
          description = "Check flakemill for a newer flake.lock";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "1min";
            OnUnitActiveSec = "12min";
          };
        };

        systemd.services.nix-update-check = {
          description = "Check flakemill for a newer flake.lock";
          environment = clientEnv // {
            HOME = user.home;
          };
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStart = "${nix-update-check}/bin/nix-update-check";
            TimeoutStartSec = "10min";
          };
        };

        systemd.paths.nix-update-lock-changed = {
          description = "Watch for local flake lock updates";
          wantedBy = [ "multi-user.target" ];
          pathConfig.PathChanged = "${repo}/flake.lock";
        };

        systemd.services.nix-update-lock-changed = {
          description = "Clear and refresh flake update status";
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStartPost = "+${config.systemd.package}/bin/systemctl start --no-block nix-update-check.service";
          };
          path = [ pkgs.coreutils ];
          script = "rm -f ${lib.escapeShellArg statusFile}";
        };
      };
  };
}
