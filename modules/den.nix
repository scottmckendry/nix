{
  inputs,
  lib,
  den,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];
  systems = [ "x86_64-linux" ];
  _module.args.utils = import ../utils;

  den.schema.user.classes = lib.mkDefault [ "hjem" ];

  den.aspects.scott = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
      (den.provides.user-shell "zsh")
    ];
  };

  den.hosts.x86_64-linux.atlas = {
    users.scott = { };
    swapSize = 16 * 1024;
  };

  den.hosts.x86_64-linux.eris = {
    users.scott = { };
    luksDevices = [ "luks-0074ecff-31d1-498a-9571-b38b8b85a1fd" ];
    swapSize = 32 * 1024;
    swapResumeOffset = 14282244;
  };
}
