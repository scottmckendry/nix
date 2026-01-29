{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lazygit
  ];
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Scott McKendry";
        email = "me@scottmckendry.tech";
      };
      alias = {
        co = "checkout";
        hist = ''log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'';
      };
    };
  };
  programs.delta = {
    enable = true;
    options = {
      side-by-side = true;
      syntax-theme = "cyberdream";
    };
  };
}
