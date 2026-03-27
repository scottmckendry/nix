{ ... }:
{
  den.aspects.swap = {
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
