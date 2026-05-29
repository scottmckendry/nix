final: prev: {
  btop-kitty = prev.writeShellApplication {
    name = "btop-kitty";
    runtimeInputs = [
      prev.kitty
      prev.jq
    ];
    text = ''
      # Try opening btop in a new tab of an existing kitty via remote control socket.
      # Falls back to launching a new kitty window if no socket available.
      if kitty @ --to "unix:/tmp/kitty-socket" launch --type=tab --cwd=current btop 2>/dev/null; then
        # Focus window in niri
        if [ -S "$NIRI_SOCKET" ] 2>/dev/null; then
          win_id=$(niri msg -j windows 2>/dev/null | jq -r '[.[] | select(.app_id == "kitty") | .id] | first // empty')
          [ -n "$win_id" ] && niri msg action focus-window --id "$win_id" 2>/dev/null || true
        fi
        exit 0
      fi
      exec kitty -e btop
    '';
  };
}
