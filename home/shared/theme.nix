{ pkgs, ... }:

{
  # Cyberdream theme - shared across kitty, delta, etc.
  _module.args.cyberdream = pkgs.fetchFromGitHub {
    owner = "scottmckendry";
    repo = "cyberdream.nvim";
    rev = "main";
    sha256 = "sha256-iU4HgEzjcZ/UE+aapTGWRcilaLmUy/QQnuIaTFT63Zg=";
  };
}
