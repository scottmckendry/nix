{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Scott McKendry";
    userEmail = "me@scottmckendry.tech";
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
