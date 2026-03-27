{ ... }:
{
  den.aspects.virtualisation = {
    nixos =
      { pkgs, ... }:
      {
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
        users.users.scott.extraGroups = [ "libvirtd" ];
      };
  };
}
