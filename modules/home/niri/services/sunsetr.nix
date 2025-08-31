{ pkgs, inputs, ... }:
let
  package = inputs.sunsetr.packages.${pkgs.system}.sunsetr;
in
{
  systemd.user.services.sunsetr = {
    Unit = {
      Description = "Sunsetr daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${package}/bin/sunsetr";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.packages = [ package ];

  # see https://github.com/psi4j/sunsetr?tab=readme-ov-file#%EF%B8%8F-configuration
  xdg.configFile."sunsetr/sunsetr.toml".text = ''
    transition_mode = "geo"
    night_temp = 3400
    night_gamma = 100
    latitude = -36.830985
    longitude = 174.745519

    # required fields, but ignored in geo mode
    sunset = "00:00:00"
    sunrise = "12:00:00"
  '';
}
