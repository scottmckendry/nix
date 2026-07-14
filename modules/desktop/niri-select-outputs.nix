{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        niri-select-outputs = pkgs.writeShellApplication {
          name = "niri-select-outputs";
          runtimeInputs = [ pkgs.usbutils ];
          text = ''
            set -euo pipefail

            DOCK_USB_ID="17e9:6006"
            NIRI_DIR="''${HOME}/.config/niri"

            if lsusb | grep -q "$DOCK_USB_ID"; then
                target="output-docked.kdl"
            else
                target="output-mobile.kdl"
            fi

            ln -sfn "''${NIRI_DIR}/''${target}" "''${NIRI_DIR}/output-active.kdl"
            echo "niri outputs: using ''${target}"
          '';
        };
      in
      lib.mkIf config.programs.niri.enable {
        systemd.user.services.niri-select-outputs = {
          description = "Select niri output config based on dock presence";
          before = [ "niri-session.service" ];
          wantedBy = [ "niri-session.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${niri-select-outputs}/bin/niri-select-outputs";
          };
        };

        services.udev.extraRules = ''
          # re-select niri outputs on Dell D6000 dock connect/disconnect
          ACTION=="add", \
          ENV{ID_BUS}=="usb", \
          ENV{ID_VENDOR_ID}=="17e9", \
          ENV{ID_MODEL_ID}=="6006", \
          RUN+="${pkgs.su}/bin/su scott -c 'HOME=/home/scott ${niri-select-outputs}/bin/niri-select-outputs'"

          ACTION=="remove", \
          ENV{ID_BUS}=="usb", \
          ENV{ID_VENDOR_ID}=="17e9", \
          ENV{ID_MODEL_ID}=="6006", \
          RUN+="${pkgs.su}/bin/su scott -c 'HOME=/home/scott ${niri-select-outputs}/bin/niri-select-outputs'"
        '';
      };
  };
}
