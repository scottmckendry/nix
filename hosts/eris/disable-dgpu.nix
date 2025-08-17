{ ... }:

{
  # Nvidia causes all sorts of problems, so if I can disable it, I will.

  # The main issue with this particually hardware, is that deep sleep is not supported.
  # Therefore, to get anywhere near decent battery life while sleeping, hibernation is required.

  # systemd's hibernation works fine, but it's also slow to resume. suspend works too, but drains the battery too quickly.
  # suspend-then-hibernate strikes a good balance. no matter what, I could not get it to work with the nvidia driver.
  # so, here we are.

  # see https://nixos.wiki/wiki/Nvidia
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';
  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
  ];
}
