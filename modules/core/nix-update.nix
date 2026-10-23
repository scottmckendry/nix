{ ... }:
{
  den.aspects.core = {
    nixos =
      { pkgs, config, ... }:
      let
        user = config.users.users.scott;
        pendingLock = "${user.home}/.cache/nix-update-pending.lock";
        builtLock = "${user.home}/.cache/nix-update-built.lock";
        commonEnv = [
          "HOME=${user.home}"
          "PATH=/run/wrappers/bin:/run/current-system/sw/bin:${user.home}/.nix-profile/bin"
          "NIX_REPO_DIR=${user.home}/git/nix"
          "NIX_UPDATE_PENDING=${pendingLock}"
          "NIX_UPDATE_BUILT=${builtLock}"
        ];

        nix-update-check = pkgs.writeShellApplication {
          name = "nix-update-check";
          runtimeInputs = with pkgs; [
            coreutils
            diffutils
            jq
          ];
          text = ''
            readonly REPO_DIR="''${NIX_REPO_DIR:-$HOME/git/nix}"
            readonly CACHE="''${NIX_UPDATE_CACHE:-$HOME/.cache/nix-update-status}"
            readonly PENDING="''${NIX_UPDATE_PENDING:-$HOME/.cache/nix-update-pending.lock}"

            desired=$(mktemp)
            err=$(mktemp)

            if ! nix flake update --flake "$REPO_DIR" --output-lock-file "$desired" >/dev/null 2>"$err"; then
                printf 'offline\n'
                cat "$err" >&2
                rm -f "$desired" "$err"
                exit 0
            fi

            if jq -S . "$REPO_DIR/flake.lock" | cmp -s - <(jq -S . "$desired"); then
                printf 'current\n'
                rm -f "$CACHE" "$PENDING"
            else
                printf 'stale\n'
                cat "$err"
                mkdir -p "$(dirname "$CACHE")"
                printf '' >"$CACHE"
                if [[ ! -f $PENDING ]] || ! cmp -s "$PENDING" "$desired"; then
                    cp "$desired" "$PENDING"
                fi
            fi

            rm -f "$desired" "$err"
          '';
        };

        nix-update-prebuild = pkgs.writeShellApplication {
          name = "nix-update-prebuild";
          runtimeInputs = with pkgs; [
            coreutils
            git
          ];
          text = ''
            readonly REPO_DIR="''${NIX_REPO_DIR:-$HOME/git/nix}"
            readonly PENDING="''${NIX_UPDATE_PENDING:-$HOME/.cache/nix-update-pending.lock}"
            readonly BUILT="''${NIX_UPDATE_BUILT:-$HOME/.cache/nix-update-built.lock}"
            readonly PREBUILD_BRANCH="''${NIX_UPDATE_PREBUILD_BRANCH:-ci/prebuild}"

            [[ -s $PENDING ]] || exit 0

            pending_hash=$(git hash-object "$PENDING")
            if [[ -f $BUILT ]] && [[ $(<"$BUILT") == "$pending_hash" ]]; then
                exit 0
            fi

            cd "$REPO_DIR"

            base=$(git stash create "prebuild $(date -u +%Y%m%dT%H%M%SZ)") || true
            if [[ -z $base ]]; then
                base=$(git rev-parse HEAD)
            fi

            blob=$(git hash-object -w "$PENDING")
            index=$(mktemp)
            trap 'rm -f "$index"' EXIT
            GIT_INDEX_FILE=$index git read-tree "$base"
            GIT_INDEX_FILE=$index git update-index --add --cacheinfo 100644 "$blob" flake.lock
            tree=$(GIT_INDEX_FILE=$index git write-tree)
            commit=$(printf 'prebuild %s\n' "$(date -u +%Y%m%dT%H%M%SZ)" | git commit-tree "$tree" -p "$base")

            printf '==> Pushing %s to %s\n' "''${commit:0:12}" "$PREBUILD_BRANCH"
            git push --force origin "$commit:refs/heads/$PREBUILD_BRANCH"

            mkdir -p "$(dirname "$BUILT")"
            printf '%s\n' "$pending_hash" >"$BUILT"
          '';
        };
      in
      {
        systemd.timers.nix-update-check = {
          description = "Check for nix flake updates";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "5min";
            OnUnitActiveSec = "1h";
            RandomizedDelaySec = "5min";
          };
        };
        systemd.services.nix-update-check = {
          description = "Check for nix flake updates";
          unitConfig.OnSuccess = [ "nix-update-prebuild.service" ];
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStart = "${nix-update-check}/bin/nix-update-check";
            Environment = commonEnv;
          };
        };

        systemd.services.nix-update-prebuild = {
          description = "Prebuild pending flake.lock on GitHub Actions";
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStart = "${nix-update-prebuild}/bin/nix-update-prebuild";
            Environment = commonEnv;
          };
        };
      };
  };
}
