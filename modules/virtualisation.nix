{ pkgs, username, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    spice-gtk
    win-virtio
    win-spice
  ];

  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" ];
}
