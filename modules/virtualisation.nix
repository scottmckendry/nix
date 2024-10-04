{ pkgs, username, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
    };
  };

  environment.systemPackages = with pkgs; [
    spice-gtk
    win-virtio
    win-spice
  ];

  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [ "libvirtd" ];
}
