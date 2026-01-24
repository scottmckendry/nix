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
  home.file.".ssh/authorized_keys".text = builtins.readFile (
    pkgs.fetchurl {
      url = "https://github.com/scottmckendry.keys";
      sha256 = "EF8jlfRIzg+pEqPkCq9HYB/niYksYUYfCoHxaxs6C/U=";
    }
  );
}
