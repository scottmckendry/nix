{ ... }:
{
  den.aspects.core = {
    nixos =
      { pkgs, config, ... }:
      let
        user = config.users.users.scott;

        nix-update-check = pkgs.writeShellApplication {
          name = "nix-update-check";
          runtimeInputs = with pkgs; [
            coreutils
            diffutils
            gh
            jq
          ];
          text = ''
            readonly REPO_DIR="''${NIX_REPO_DIR:-$HOME/git/nix}"
            readonly CACHE="''${NIX_UPDATE_CACHE:-$HOME/.cache/nix-update-status}"
            readonly DISPATCHED="''${NIX_UPDATE_DISPATCHED:-$HOME/.cache/nix-update-dispatched}"
            readonly GH_REPO="''${NIX_UPDATE_GH_REPO:-scottmckendry/nix}"
            readonly WORKFLOW="''${NIX_UPDATE_WORKFLOW:-build.yml}"

            desired=$(mktemp)
            err=$(mktemp)
            trap 'rm -f "$desired" "$err"' EXIT

            if ! nix flake update --flake "$REPO_DIR" --output-lock-file "$desired" >/dev/null 2>"$err"; then
                printf 'offline\n'
                cat "$err" >&2
                exit 0
            fi

            if jq -S . "$REPO_DIR/flake.lock" | cmp -s - <(jq -S . "$desired"); then
                printf 'current\n'
                rm -f "$CACHE"
                exit 0
            fi

            printf 'stale\n'
            mkdir -p "$(dirname "$CACHE")" "$(dirname "$DISPATCHED")"
            printf '' >"$CACHE"

            hash=$(sha256sum "$desired" | cut -d' ' -f1)
            if [[ -f $DISPATCHED ]] && [[ $(<"$DISPATCHED") == "$hash" ]]; then
                exit 0
            fi

            printf '==> Dispatching %s on %s\n' "$WORKFLOW" "$GH_REPO" >&2
            if gh workflow run "$WORKFLOW" --repo "$GH_REPO" -f update=true; then
                printf '%s\n' "$hash" >"$DISPATCHED"
            else
                printf 'failed to dispatch %s\n' "$WORKFLOW" >&2
            fi
          '';
        };
      in
      {
        systemd.timers.nix-update-check = {
          description = "Check for nix flake updates";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "5min";
            OnUnitActiveSec = "15min";
            RandomizedDelaySec = "2min";
          };
        };

        systemd.services.nix-update-check = {
          description = "Check for nix flake updates";
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStart = "${nix-update-check}/bin/nix-update-check";
            Environment = [
              "HOME=${user.home}"
              "PATH=/run/wrappers/bin:/run/current-system/sw/bin:${user.home}/.nix-profile/bin"
              "NIX_REPO_DIR=${user.home}/git/nix"
            ];
          };
        };
      };
  };
}
