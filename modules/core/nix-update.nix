{ ... }:
{
  den.aspects.core = {
    nixos =
      { pkgs, config, ... }:
      let
        user = config.users.users.scott;
        nix-update = pkgs.writeShellApplication {
          name = "nix-update";
          runtimeInputs = with pkgs; [
            coreutils
            gh
            git
            gnugrep
            jq
            nh
          ];
          text = builtins.readFile ./nix-update.sh;
        };
      in
      {
        environment.systemPackages = [ nix-update ];

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
            User = user.name;
            ExecStart = "${nix-update}/bin/nix-update glyph";
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
