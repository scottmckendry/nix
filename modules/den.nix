{
  inputs,
  den,
  lib,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];

  systems = [ "x86_64-linux" ];

  # All users use home-manager by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # Enable host↔user aspect routing (needed for host aspects to contribute
  # homeManager config to their users, e.g. scott-desktop → scott)
  den.ctx.user.includes = [ den._.mutual-provider ];

  den.hosts.x86_64-linux.atlas = {
    users.scott = { };
    plymouthTheme = "spinner";
    output = "DP-1";
  };

  den.hosts.x86_64-linux.eris = {
    users.scott = { };
    plymouthTheme = "fade-in";
    output = "eDP-1";
    luksDevices = [ "luks-0074ecff-31d1-498a-9571-b38b8b85a1fd" ];
  };

  den.hosts.x86_64-linux.helios = {
    users.scott = { };
  };

  # Standalone home replaces homeConfigurations.default
  den.homes.x86_64-linux."scott@default" = { };
}
