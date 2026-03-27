{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.custom.services.virtualisation;
in
{
  options.custom.services.virtualisation = {
    enable = lib.mkEnableOption "libvirt virtualization with virt-manager";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };

    environment.systemPackages = with pkgs; [
      spice-gtk
      virtio-win
      win-spice
    ];

    programs.virt-manager.enable = true;
    users.users.${username}.extraGroups = [ "libvirtd" ];
  };
}
