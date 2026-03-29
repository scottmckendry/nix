{ inputs, lib, ... }:
{
  imports = [ inputs.den.flakeModule ];
  systems = [ "x86_64-linux" ];
  _module.args.utils = import ../utils;

  den.schema.user.classes = lib.mkDefault [ "hjem" ];

  den.hosts.x86_64-linux.atlas = {
    users.scott = { };
    plymouthTheme = "spinner";
    swapSize = 16 * 1024;
  };

  den.hosts.x86_64-linux.eris = {
    users.scott = { };
    plymouthTheme = "fade-in";
    luksDevices = [ "luks-0074ecff-31d1-498a-9571-b38b8b85a1fd" ];
    swapSize = 32 * 1024;
    swapResumeOffset = 14282244;
  };
}
