{ config, inputs, ... }:
{
  programs.yazi = {
    enable = true;

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;

    settings = {
      manager = {
        show_hidden = true;
        linemode = "size";
      };
    };
  };

  # theme
  xdg.configFile."yazi/theme.toml".source = "${inputs.cyberdream.extras.yazi}/cyberdream.toml";
}
