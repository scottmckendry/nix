{ ... }:
{
  den.aspects.displaylink = {
    nixos =
      { pkgs, config, ... }:
      # TODO: remove entire let block when available in unstable channel
      # https://github.com/NixOS/nixpkgs/pull/576405
      let
        evdi = config.boot.kernelPackages.evdi.overrideAttrs (old: {
          makeFlags = builtins.filter (flag: flag != "module") old.makeFlags ++ [
            "DESTDIR=${placeholder "out"}"
          ];
          buildFlags = [ "module" ];
          installFlags = [
            "-C"
            "module"
          ];
          installPhase = null;
          postInstall = ''
            install -Dm755 library/libevdi.so $out/lib/libevdi.so
          '';
        });
      in
      {
        boot = {
          extraModulePackages = [ evdi ];
          kernelModules = [ "evdi" ];
        };

        environment.systemPackages = [ pkgs.displaylink ];
        services.xserver.videoDrivers = [
          "modesetting"
          "displaylink"
        ];

        # only run dlm.service when a DisplayLink device is connected
        services.udev.extraRules = ''
          ACTION=="add", SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="17e9", RUN+="${config.systemd.package}/bin/systemctl --no-block start dlm.service"
          ACTION=="remove", SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="17e9", RUN+="${config.systemd.package}/bin/systemctl --no-block stop dlm.service"
        '';
      };
  };
}
