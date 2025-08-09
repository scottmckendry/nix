{ pkgs, lib, ... }:
{
  # see https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
