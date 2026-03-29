# mkWaylandService — builds a systemd.user.services.<name> attrset for a
# Wayland session daemon with the standard graphical-session wiring.
{
  description,
  execStart,
  type ? "simple",
  extraServiceConfig ? { },
  wantedBy ? true,
}:
{
  inherit description;
  partOf = [ "graphical-session.target" ];
  after = [ "graphical-session-pre.target" ];
}
// (if wantedBy then { wantedBy = [ "graphical-session.target" ]; } else { })
// {
  serviceConfig = {
    Type = type;
    ExecStart = execStart;
    Restart = "on-failure";
    RestartSec = 1;
    Environment = "PATH=/run/current-system/sw/bin:%h/.nix-profile/bin";
  }
  // extraServiceConfig;
}
