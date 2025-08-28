{ pkgs, ... }:

{
  imports = [
    ./config
    ./hyprlock.nix
    ./mako.nix
    ./services
  ];

  home.packages = with pkgs; [
    blueberry
    brightnessctl
    cliphist
    inotify-tools
    networkmanagerapplet
    playerctl
    waybar
  ];

  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "~/scripts/hyprlock.sh" ]; }
    ];
    environment = {
      DISPLAY = ":0";
    };
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
  };

  # Mask nm-applet autostart to prevent tray icon
  xdg.configFile."autostart/nm-applet.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
