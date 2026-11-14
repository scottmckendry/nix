{ ... }:
{
  den.aspects.nix-update = {
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
        lockFile = "${statusFile}.lock";
        millPubKey = pkgs.writeText "flakemill.pub" mill.publicKey;
        indicator = "";

        nix-update-check = pkgs.writeShellApplication {
          name = "nix-update-check";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.curl
            pkgs.diffutils
            pkgs.minisign
            pkgs.util-linux
          ];
          text = ''
            readonly URL="${mill.url}"
            readonly LOCK="${repo}/flake.lock"
            readonly STATUS="${statusFile}"
            readonly PUBKEY="${millPubKey}"
            tmp=$(mktemp -d)
            trap 'rm -rf "$tmp"' EXIT

            mkdir -p "$(dirname "$STATUS")"
            # Copy the key alongside the lock so they're verified together.
            cp "$PUBKEY" "$tmp/flakemill.pub"
            curl -fsS --max-time 60 "$URL/flake.lock" -o "$tmp/updated.lock"
            curl -fsS --max-time 60 "$URL/flake.lock.minisig" \
              -o "$tmp/flake.lock.minisig"
            minisign -Vm "$tmp/updated.lock" -p "$tmp/flakemill.pub"

            # Serialize publication with the path-triggered cache clear.
            exec 9>"$STATUS.lock"
            flock 9

            if cmp -s "$LOCK" "$tmp/updated.lock"; then
                rm -f "$STATUS"
              else
                # Publish atomically: starship reads this without the lock. Write
                # the glyph too so older configs that cat the file still work.
                printf '%s' ${lib.escapeShellArg indicator} >"$STATUS.tmp"
                mv -f "$STATUS.tmp" "$STATUS"
              fi
          '';
        };

        # Applies the mill's published lock to the source checkout.
        up = pkgs.writeShellApplication {
          name = "up";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.curl
            pkgs.minisign
            pkgs.util-linux
          ];
          text = ''
            readonly URL="${mill.url}"
            readonly LOCK="${repo}/flake.lock"
            readonly STATUS="${statusFile}"
            readonly PUBKEY="${millPubKey}"
            tmp=$(mktemp -d)
            trap 'rm -rf "$tmp"' EXIT

            # Fetch and verify the mill's published lock.
            cp "$PUBKEY" "$tmp/flakemill.pub"
            curl -fsS --max-time 60 "$URL/flake.lock" -o "$tmp/flake.lock"
            curl -fsS --max-time 60 "$URL/flake.lock.minisig" \
              -o "$tmp/flake.lock.minisig"
            minisign -Vm "$tmp/flake.lock" -p "$tmp/flakemill.pub"

            if cmp -s "$LOCK" "$tmp/flake.lock"; then
              echo "already up to date"
              exit 0
            fi

            exec 9>"$STATUS.lock"
            flock 9
            cp "$tmp/flake.lock" "$LOCK.tmp"
            mv -f "$LOCK.tmp" "$LOCK"
            # Update consumed; drop the starship indicator.
            rm -f "$STATUS"
            echo "rolled in fleet lock"
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

        environment.systemPackages = [ up ];

        systemd.timers.nix-update-check = {
          description = "Check for flake updates upstream";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "1min";
            OnUnitActiveSec = "30min";
          };
        };

        systemd.services.nix-update-check = {
          description = "Check for flake updates upstream";
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStart = "${nix-update-check}/bin/nix-update-check";
            TimeoutStartSec = "5min";
            Environment = [ "HOME=${user.home}" ];
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
          path = [
            pkgs.coreutils
            pkgs.util-linux
          ];
          script = ''
            mkdir -p ${lib.escapeShellArg cacheDir}
            exec 9>${lib.escapeShellArg lockFile}
            flock 9
            rm -f ${lib.escapeShellArg statusFile}
          '';
        };
      };
  };
}
