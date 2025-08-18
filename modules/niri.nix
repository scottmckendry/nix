{ pkgs, username, ... }:

{
  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;

  services.displayManager = {
    gdm = {
      enable = true;
    };
    autoLogin.enable = true;
    autoLogin.user = username;
  };

  environment.etc."xdg/wayland-sessions/niri.desktop".text = ''
    [Desktop Entry]
    Name=Niri
    Comment=Start Niri session
    Exec=${pkgs.niri}/bin/niri-session
    Type=Application
    DesktopNames=Niri
  '';

}
