{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.boot.secure-boot;
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.custom.boot.secure-boot = {
    enable = lib.mkEnableOption "secure boot with lanzaboote";

    pkiBundle = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/sbctl";
      description = "Path to the PKI bundle for secure boot keys";
    };
  };

  config = lib.mkIf cfg.enable {
    # see https://github.com/nix-community/lanzaboote/blob/master/docs
    environment.systemPackages = with pkgs; [
      sbctl
    ];

    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = cfg.pkiBundle;
    };
  };
}
