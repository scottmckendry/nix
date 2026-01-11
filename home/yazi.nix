{ pkgs, config, ... }:

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
  xdg.configFile."yazi/theme.toml".source =
    (pkgs.fetchFromGitHub {
      owner = "scottmckendry";
      repo = "cyberdream.nvim";
      rev = "main";
      sha256 = "sha256-iU4HgEzjcZ/UE+aapTGWRcilaLmUy/QQnuIaTFT63Zg=";
    })
    + "/extras/yazi/cyberdream.toml";
}
