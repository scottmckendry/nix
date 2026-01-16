{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./k9s.nix
    ./lazygit.nix
    ./opencode.nix
    ./posting.nix
  ];

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-markdown-preview ];
  };
}
