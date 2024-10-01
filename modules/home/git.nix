{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Scott McKendry";
    userEmail = "39483124+scottmckendry@users.noreply.github.com";
    aliases = {
      co = "checkout";
      hist = ''log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'';
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        syntax-theme = "cyberdream";
      };
    };
  };
}
