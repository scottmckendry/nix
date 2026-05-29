{ ... }:
{
  den.aspects.packages = {
    nixos =
      { pkgs, ... }:
      let
        nvim-xdg = pkgs.writeShellApplication {
          name = "nvim-xdg";
          runtimeInputs = [
            kitty-wrapped
            pkgs.jq
          ];
          text = ''
            # Try to open a new tab in an existing kitty window via remote control socket.
            # Falls back to launching a new kitty window if no socket is available.
            if kitty @ --to "unix:/tmp/kitty-socket" launch --type=tab --cwd=current nvim "$@" 2>/dev/null; then
              # Focus window in niri
              if [ -S "$NIRI_SOCKET" ] 2>/dev/null; then
                win_id=$(niri msg -j windows 2>/dev/null | jq -r '[.[] | select(.app_id == "kitty") | .id] | first // empty')
                [ -n "$win_id" ] && niri msg action focus-window --id "$win_id" 2>/dev/null || true
              fi
              exit 0
            fi

            exec kitty -e nvim "$@"
          '';
        };

        kitty-wrapped = pkgs.writeShellApplication {
          name = "kitty";
          runtimeInputs = [ pkgs.kitty ];
          text = ''
            SOCKET="/tmp/kitty-socket"

            if [ "''${1:-}" = "@" ]; then
              exec ${pkgs.kitty}/bin/kitty "$@"
            fi

            if ${pkgs.kitty}/bin/kitty @ --to "unix:$SOCKET" ls >/dev/null 2>&1; then
              exec ${pkgs.kitty}/bin/kitty --single-instance "$@"
            fi

            if [ -S "$SOCKET" ]; then
              rm -f "$SOCKET"
            fi

            exec ${pkgs.kitty}/bin/kitty --single-instance --listen-on "unix:$SOCKET" "$@"
          '';
        };

        nvim-xdg-desktop = pkgs.makeDesktopItem {
          name = "nvim-xdg";
          desktopName = "Neovim";
          exec = "nvim-xdg %f";
          icon = "nvim";
          categories = [
            "Utility"
            "TextEditor"
          ];
          terminal = false;
        };
      in
      {
        environment.systemPackages = [
          kitty-wrapped
          nvim-xdg
          nvim-xdg-desktop
        ];
      };
  };
}
