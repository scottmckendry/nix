{ ... }:
{
  imports = [
    ./bat.nix
    ./eza.nix
    ./fastfetch.nix
    ./starship.nix
    ./yazi.nix
    ./zsh.nix
  ];

  programs.zoxide.enable = true;
}
