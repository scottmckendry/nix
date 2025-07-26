{ pkgs, ... }:
{
  # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprscrolling
  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprscrolling
    ];

     settings = {
      plugin.hyprscrolling = {
        fullscreen_on_one_column = true;
      };
      general = {
        layout = "scrolling";
      };
      bind = [
        "$mainMod, P, exec, hyprctl dispatch layoutmsg promote"
      ];
    };
  };
}