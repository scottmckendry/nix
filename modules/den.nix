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

  # Enable host→user aspect routing (needed for host aspects to push
  # homeManager config to their users via provides.to-users)
  den.ctx.user.includes = [ den._.mutual-provider ];

  den.hosts.x86_64-linux.atlas = {
    users.scott = { };
    plymouthTheme = "spinner";
    output = "DP-1";
    swapSize = 16 * 1024;
  };

  den.hosts.x86_64-linux.eris = {
    users.scott = { };
    plymouthTheme = "fade-in";
    output = "eDP-1";
    luksDevices = [ "luks-0074ecff-31d1-498a-9571-b38b8b85a1fd" ];
    swapSize = 32 * 1024;
    swapResumeOffset = 14282244;
  };

  # Standalone home (non-NixOS, e.g. ubuntu) for development and testing of home-manager configs
  den.homes.x86_64-linux."scott@default" = { };
}
