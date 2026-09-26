{ ... }:
{
  den.aspects.core = {
    nixos =
      { pkgs, ... }:
      let
        nix-update-check = pkgs.writeShellApplication {
          name = "nix-update-check";
          runtimeInputs = [
            pkgs.gh
            pkgs.git
            pkgs.jq
          ];
          text = ''
            CACHE="$HOME/.cache/nix-update-status"
            REPO="scottmckendry/nix"

            mkdir -p "$(dirname "$CACHE")"

            pr_json=$(gh pr list --repo "$REPO" --label nix --state open \
                --json number,labels --limit 1 2>/dev/null || echo "[]")

            if [ "$pr_json" != "[]" ]; then
                labels=$(echo "$pr_json" | jq -r '.[0].labels[].name' 2>/dev/null || true)
                if echo "$labels" | grep -qw "cachix-ready"; then
                    echo "" >"$CACHE"
                elif echo "$labels" | grep -qw "build-failed"; then
                    echo "" >"$CACHE"
                else
                    echo "󱤛" >"$CACHE"
                fi
            else
                local=$(git -C "$HOME/git/nix" rev-parse HEAD 2>/dev/null || echo "")
                remote=$(gh api "repos/$REPO/git/ref/heads/main" \
                    --jq .object.sha 2>/dev/null || echo "")
                if [ -n "$local" ] && [ -n "$remote" ] && [ "$local" != "$remote" ]; then
                    echo "behind" >"$CACHE"
                else
                    : >"$CACHE"
                fi
            fi
          '';
        };
      in
      {
        systemd.timers.nix-update-check = {
          description = "Check for nix flake updates";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "1min";
            OnUnitActiveSec = "5min";
          };
        };
        systemd.services.nix-update-check = {
          description = "Check for nix flake updates";
          serviceConfig = {
            Type = "oneshot";
            User = "scott";
            ExecStart = "${nix-update-check}/bin/nix-update-check";
            Environment = [
              "HOME=/home/scott"
              "PATH=/run/wrappers/bin:/run/current-system/sw/bin:/home/scott/.nix-profile/bin"
            ];
          };
        };
      };
  };
}
