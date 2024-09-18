{ ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
    };

    # window manager keybind overrides
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
    };

    # shell keybind overrides
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Shift><Super>s" ];
    };

    # custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "alacritty";
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "File Manager";
      command = "nautilus";
      binding = "<Super>E";
    };
  };
}
