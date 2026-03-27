{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.boot.tpm2-luks;
in
{
  options.custom.boot.tpm2-luks = {
    enable = lib.mkEnableOption "TPM2 LUKS unlocking";

    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of LUKS device names to unlock with TPM2";
      example = [ "luks-0074ecff-31d1-498a-9571-b38b8b85a1fd" ];
    };

    pcrs = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ 7 ];
      description = "PCR banks to bind the key to";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable TPM2 support in initrd
    boot.initrd.systemd.enable = true;

    # Configure LUKS devices for TPM2 unlocking
    boot.initrd.luks.devices = lib.mkMerge (
      map (deviceName: {
        ${deviceName} = {
          crypttabExtraOpts = [
            "tpm2-device=auto"
            "headless=yes"
            "timeout=10s"
          ];
        };
      }) cfg.devices
    );

    # Ensure required packages are available
    environment.systemPackages = with pkgs; [
      tpm2-tss
      tpm2-tools
    ];
  };
}
