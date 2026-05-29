final: prev: {
  btop-kitty = prev.writeShellApplication {
    name = "btop-kitty";
    runtimeInputs = [ prev.kitty ];
    text = ''
      # Try opening btop in a new tab of an existing kitty via remote control socket.
      # Falls back to launching a new kitty window if no socket available.
      if kitty @ --to "unix:/tmp/kitty-socket" launch --type=tab --cwd=current btop 2>/dev/null; then
        exit 0
      fi
      exec kitty -e btop
    '';
  };
}
