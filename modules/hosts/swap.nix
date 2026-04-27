{ ... }:
{
  den.aspects.silent-boot = {
    includes = [
      (
        { host, ... }:
        {
          nixos.swapDevices = [
            {
              device = "/swapfile";
              size = host.swapSize;
            }
          ];
        }
      )
    ];
  };
}
