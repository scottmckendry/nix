{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-0074ecff-31d1-498a-9571-b38b8b85a1fd";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  boot.initrd.luks.devices."luks-0074ecff-31d1-498a-9571-b38b8b85a1fd".device =
    "/dev/disk/by-uuid/0074ecff-31d1-498a-9571-b38b8b85a1fd";

  # TPM2 LUKS unlocking
  custom.boot.tpm2-luks.enable = true;
  custom.boot.tpm2-luks.devices = [ "luks-0074ecff-31d1-498a-9571-b38b8b85a1fd" ];

  fileSystems."/home" = {
    device = "/dev/mapper/luks-0074ecff-31d1-498a-9571-b38b8b85a1fd";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/989B-9ED0";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
