final: prev: {
  nvim-xdg = prev.symlinkJoin {
    name = "nvim-xdg";
    paths = [
      (prev.writeShellApplication {
        name = "nvim-xdg";
        runtimeInputs = [
          final.kitty-wrapped
          prev.jq
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
      })
      (prev.makeDesktopItem {
        name = "nvim-xdg";
        desktopName = "Neovim";
        exec = "nvim-xdg %f";
        icon = "nvim";
        categories = [
          "Utility"
          "TextEditor"
        ];
        terminal = false;
      })
    ];
  };
}
