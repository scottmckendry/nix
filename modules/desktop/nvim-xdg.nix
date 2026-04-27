{ ... }:
{
  den.aspects.packages = {
    nixos =
      { pkgs, ... }:
      let
        nvim-xdg = pkgs.writeShellApplication {
          name = "nvim-xdg";
          runtimeInputs = [ pkgs.kitty ];
          text = ''
            # Try to open a new tab in an existing kitty window via remote control socket.
            # Falls back to launching a new kitty window if no socket is available.
            if kitty @ --to unix:/tmp/kitty-socket launch --type=tab --cwd=current nvim "$@" 2>/dev/null; then
              exit 0
            fi
            kitty --listen-on unix:/tmp/kitty-socket -e nvim "$@"
          '';
        };

        kitty-wrapped = pkgs.symlinkJoin {
          name = "kitty";
          paths = [ pkgs.kitty ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/kitty \
              --add-flags "--listen-on unix:/tmp/kitty-socket"
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
