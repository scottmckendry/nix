final: prev: {
  kitty-wrapped = prev.writeShellApplication {
    name = "kitty";
    runtimeInputs = [ prev.kitty ];
    text = ''
      SOCKET="/tmp/kitty-socket"

      if [ "''${1:-}" = "@" ]; then
        exec ${prev.kitty}/bin/kitty "$@"
      fi

      if ${prev.kitty}/bin/kitty @ --to "unix:$SOCKET" ls >/dev/null 2>&1; then
        exec ${prev.kitty}/bin/kitty --single-instance "$@"
      fi

      if [ -S "$SOCKET" ]; then
        rm -f "$SOCKET"
      fi

      exec ${prev.kitty}/bin/kitty --single-instance --listen-on "unix:$SOCKET" "$@"
    '';
  };
}
