{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "cyberdream";
    };
    themes = {
      cyberdream = {
        src = pkgs.fetchFromGitHub {
          owner = "scottmckendry";
          repo = "cyberdream.nvim";
          rev = "main";
          sha256 = "sha256-iU4HgEzjcZ/UE+aapTGWRcilaLmUy/QQnuIaTFT63Zg=";
        };
        file = "extras/textmate/cyberdream.tmTheme";
      };
    };
  };
}
